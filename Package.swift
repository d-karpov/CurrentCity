// swift-tools-version: 5.10

import PackageDescription

let package = Package(
	name: "CurrentCity",
	platforms: [
		.iOS(.v17),
	],
	products: [
		.library(
			name: "CurrentCity",
			targets: ["CurrentCity"]),
	],
	targets: [
		.target(name: "CurrentCity"),
	]
)
