// swift-tools-version:5.4
import PackageDescription


let package = Package(
	name: "tmignore",
	platforms: [
		.macOS(.v10_13)
	],
	products: [
		.executable(name: "tmignore", targets: ["tmignore"])
	],
	dependencies: [
		.package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.9.0"),
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.0.3"),
		.package(url: "https://github.com/apple/swift-log.git", from: "1.2.0"),
		.package(url: "https://github.com/samuelmeuli/swift-exec.git", from: "0.1.1"),
		.package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0")
	],
	targets: [
		.executableTarget(name: "tmignore", dependencies: [
			.product(name: "ArgumentParser", package: "swift-argument-parser"),
			.product(name: "HeliumLogger",   package: "HeliumLogger"),
			.product(name: "Logging",        package: "swift-log"),
			.product(name: "SwiftExec",      package: "swift-exec"),
			.product(name: "SwiftyJSON",     package: "SwiftyJSON")
		])
	]
)
