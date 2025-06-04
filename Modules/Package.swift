// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v18),
    ],
    products: [
        .library(name: .rootFeature, targets: [.rootFeature]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture",
            from: Version(1, 20, 2)
        ),
    ],
    targets: [
        .target(
            name: .rootFeature,
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
            ]
        ),
    ]
)

extension String {
    fileprivate static let rootFeature = "RootFeature"
}
