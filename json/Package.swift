// swift-tools-version:4.0
// Generated automatically by Perfect Assistant 2
// Date: 2017-10-29 18:25:07 +0000
import PackageDescription

let package = Package(
	name: "json",
	dependencies: [
		.package(url: "https://github.com/PerfectlySoft/Perfect.git", "3.0.0"..<"4.0.0")
	],
	targets: [
		.target(name: "json", dependencies: ["PerfectLib"])
	]
)
