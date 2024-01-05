// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "bridge-tigase-sqlite3.swift",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BridgeTigaseSQLite3",
            targets: ["BridgeTigaseSQLite3"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../SQLCipher")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BridgeTigaseSQLite3",
            dependencies: [
                "SQLCipher",
            ],
            cSettings: [
                .define("SQLITE_HAS_CODEC", to: "1"),
                .define("SQLITE_TEMP_STORE", to: "3"),
                .define("SQLCIPHER_CRYPTO_CC", to: nil),
                .define("NDEBUG", to: "1"),
            ],
            swiftSettings: [
                .define("SQLITE_HAS_CODEC"),
            ]
        ),
        .testTarget(
            name: "BridgeTigaseSQLite3Tests",
            dependencies: ["BridgeTigaseSQLite3"]),
    ]
)
