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
        .library(name: .dashboardFeature, targets: [.dashboardFeature]),
        .library(name: .commonUI, targets: [.commonUI]),
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
                .target(name: .commonUI),
                .target(name: .rootFeature),
            ]
        ),
        .target(
            name: .dashboardFeature,
            dependencies: [
                .product(
                    name: "ComposableArchitecture",
                    package: "swift-composable-architecture"
                ),
                .target(name: .commonUI),
            ]
        ),
        .target(
            name: .commonUI,
            dependencies: []
        ),
    ]
)

extension String {
    fileprivate static let rootFeature = "RootFeature"
    fileprivate static let dashboardFeature = "DashboardFeature"
    fileprivate static let commonUI = "CommonUI"
}
