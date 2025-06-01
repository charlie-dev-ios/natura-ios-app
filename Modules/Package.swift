// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(name: .feature, targets: [.feature]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            .upToNextMinor(from: "1.12.1")
        ),
    ],
    targets: [
        .target(
            name: .feature,
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
    ]
)

extension String {
    fileprivate static let feature = "Feature"
}
