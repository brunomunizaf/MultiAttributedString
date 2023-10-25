// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "MultiAttributedString",
  products: [
    .library(
      name: "MultiAttributedString",
      targets: ["MultiAttributedString"]
    ),
  ],
  targets: [
    .target(name: "MultiAttributedString"),
    .testTarget(
      name: "MultiAttributedStringTests",
      dependencies: ["MultiAttributedString"]
    ),
  ]
)
