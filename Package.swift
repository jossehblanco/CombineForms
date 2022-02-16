// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CombineForms",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CombineForms",
            targets: ["CombineForms"]),
    ],
    dependencies: [
        .package(name: "PostalCodeValidator", url: "https://github.com/FormatterKit/PostalCodeValidator", .upToNextMajor(from: "0.1.0")),
        .package(name: "DeviceKit", url: "https://github.com/devicekit/DeviceKit.git", from: "4.0.0"),
        .package(name: "PhoneNumberKit", url: "https://github.com/marmelroy/PhoneNumberKit", .upToNextMajor(from: "3.3.3"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CombineForms",
            dependencies: ["PostalCodeValidator", "DeviceKit", "PhoneNumberKit"]),
        .testTarget(
            name: "CombineFormsTests",
            dependencies: ["CombineForms"]),
    ]
)
