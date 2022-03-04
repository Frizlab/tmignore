import Foundation

import ArgumentParser



struct Reset : ParsableCommand {
	
	static var configuration: CommandConfiguration = .init(
		abstract: "Removes all backup exclusions that were made using tmignore"
	)
	
	func run() throws {
		let cache = Cache()
		
		/* Parse all previously added exclusions from the cache file and undo those exclusions. */
		let cachedExclusions = cache.read()
		TimeMachine.removeExclusions(paths: cachedExclusions)
		
		/* Delete the cache directory. */
		logger.info("Deleting the cache…")
		cache.clear()
		
		logger.info("Finished reset")
	}
	
}
