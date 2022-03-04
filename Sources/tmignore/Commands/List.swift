import Foundation

import ArgumentParser



struct List : ParsableCommand {
	
	static var configuration: CommandConfiguration = .init(
		abstract: "Lists all files/directories that have been excluded by tmignore"
	)
	
	func run() throws {
		let cache = Cache()
		
		/* Parse all previously added exclusions from the cache file and list those exclusions. */
		let cachedExclusions = cache.read()
		logger.info(
			"\(cachedExclusions.count) files/directories have been excluded from backups by tmignore:\n"
		)
		for path in cachedExclusions {
			logger.info("  - \(path)")
		}
	}
	
}
