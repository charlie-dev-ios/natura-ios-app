// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Modules",
  platforms: [
    .iOS(.v18),
    .macOS(.v15),
  ],
  products: [
    .library(name: .rootFeature, targets: [.rootFeature]),
    .library(name: .dashboardFeature, targets: [.dashboardFeature]),
    .library(name: .commonUI, targets: [.commonUI]),
    .library(name: .hashtagFeature, targets: [.hashtagFeature]),
    .library(name: .pipelineFeature, targets: [.pipelineFeature]),
    .library(name: .graphFeature, targets: [.graphFeature]),
    .library(name: .domain, targets: [.domain]),
  ],
  dependencies: [
    .package(
      url: "https://github.com/pointfreeco/swift-composable-architecture",
      from: Version(1, 20, 2)
    ),
    .package(
      url: "https://github.com/pointfreeco/sharing-grdb",
      from: Version(0, 4, 1)
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
        .target(name: .dashboardFeature),
        .target(name: .hashtagFeature),
        .target(name: .pipelineFeature),
        .target(name: .graphFeature),
        .target(name: .domain),
      ]
    ),
    .target(
      name: .dashboardFeature,
      dependencies: [
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        ),
        .product(
          name: "SharingGRDB",
          package: "sharing-grdb"
        ),
        .target(name: .commonUI),
      ]
    ),
    .target(
      name: .commonUI,
      dependencies: []
    ),
    .target(
      name: .hashtagFeature,
      dependencies: [
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        ),
        .product(
          name: "SharingGRDB",
          package: "sharing-grdb"
        ),
        .target(name: .commonUI),
      ]
    ),
    .target(
      name: .pipelineFeature,
      dependencies: [
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        ),
      ]
    ),
    .target(
      name: .graphFeature,
      dependencies: [
        .product(
          name: "ComposableArchitecture",
          package: "swift-composable-architecture"
        ),
      ]
    ),
    .target(
      name: .domain,
      dependencies: [
        .product(
          name: "SharingGRDB",
          package: "sharing-grdb"
        ),
      ]
    ),
  ]
)

extension String {
  fileprivate static let rootFeature = "RootFeature"
  fileprivate static let dashboardFeature = "DashboardFeature"
  fileprivate static let commonUI = "CommonUI"
  fileprivate static let hashtagFeature = "HashtagFeature"
  fileprivate static let pipelineFeature = "PipelineFeature"
  fileprivate static let graphFeature = "GraphFeature"
  fileprivate static let domain = "Domain"
}
