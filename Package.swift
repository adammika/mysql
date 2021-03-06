import PackageDescription

let package = Package(
    name: "MySQL",
    dependencies: [
        // Module map for `libmysql`
        .Package(url: "https://github.com/vapor/cmysql.git", majorVersion: 2),

        // Data structure for converting between multiple representations
        .Package(url: "https://github.com/vapor/node.git", majorVersion: 2),

        // Core extensions, type-aliases, and functions that facilitate common tasks
        .Package(url: "https://github.com/vapor/core.git", majorVersion: 2),

        // JSON parsing and serialization for storing arrays and objects in MySQL
        .Package(url: "https://github.com/vapor/json.git", majorVersion: 2),
    ]
)
