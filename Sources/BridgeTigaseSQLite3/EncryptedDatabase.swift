import Foundation
import SQLCipher

open class EncryptedDatabase: Database {
    public init (
        path: String,
        flags: Int32 = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX,
        password: String
    ) throws {
        try super.init(path: path, flags: flags)
        
        let db = self.connection
        var stmt: OpaquePointer? = nil
        
        var code = sqlite3_key(db, password, Int32(password.utf8CString.count))
        guard code == SQLITE_OK
        else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error setting key: \(errmsg)")
            throw DBError(database: self, resultCode: code) ?? DBError.internalError
        }
        
        let licensePragma = ("PRAGMA cipher_license = 'ENTER_LICENSE_KEY_HERE';" as NSString).utf8String
        
        code = sqlite3_exec(db, licensePragma, nil, nil, nil)
        guard code == SQLITE_OK
        else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error with cipher_license: \(errmsg)")
            throw DBError(database: self, resultCode: code) ?? DBError.internalError
        }
        
        code = sqlite3_prepare(db, "PRAGMA cipher_version;", -1, &stmt, nil)
        guard code == SQLITE_OK
        else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error preparing SQL: \(errmsg)")
            throw DBError(database: self, resultCode: code) ?? DBError.internalError
        }
        
        code = sqlite3_step(stmt)
        guard code == SQLITE_ROW
        else {
            let errmsg = String(cString: sqlite3_errmsg(db))
            print("Error retrieiving cipher_version: \(errmsg)")
            throw DBError(database: self, resultCode: code) ?? DBError.internalError
        }
        
        print("cipher_version: %s", sqlite3_column_text(stmt, 0) ?? "UNKNOWN")
        
        sqlite3_finalize(stmt)
    }
}
