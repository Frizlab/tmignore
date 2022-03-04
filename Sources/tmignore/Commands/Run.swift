import Foundation

import ArgumentParser



struct Run : ParsableCommand {
	
	static var configuration: CommandConfiguration = .init(
		abstract: "Searches the disk for files/directories ignored by Git and excludes them from future Time Machine backups"
	)
	
	func run() throws {
		let cache = Cache()
		
		/* Parse values specified in `config.json` file. */
		let config = try Config()
		
		/* Search file system for Git repositories. */
		var repoSet = Set<String>()
		for searchPath in config.searchPaths {
			let repoList = Git.findRepos(searchPath: searchPath, ignoredPaths: config.ignoredPaths)
			for repoPath in repoList {
				repoSet.insert(repoPath)
			}
		}
		Tmignore.logger.info("Found \(repoSet.count) Git repositories in total")
		
		/* Build list of files/directories which should be excluded from Time Machine backups. */
		Tmignore.logger.info("Building list of files to exclude from backups…")
		var exclusions = [String]()
		for repoPath in repoSet {
			for path in Git.getIgnoredFiles(repoPath: repoPath) {
				// Only exclude path from backups if it is not whitelisted
				if config.whitelist.allSatisfy({ !pathMatchesGlob(glob: $0, path: path) }) {
					exclusions.append(path)
				} else {
					Tmignore.logger.debug("Skipping whitelisted file: \(path)")
				}
			}
		}
		Tmignore.logger.info("Identified \(exclusions.count) paths to exclude from backups")
		
		/* Compare generated exclusion list with the one from the previous script run, calculate diff. */
		let cachedExclusions = cache.read()
		let (
			added: exclusionsToAdd,
			removed: exclusionsToRemove
		) = findDiff(elementsV1: cachedExclusions, elementsV2: exclusions)
		
		/* Add/remove backup exclusions */
		TimeMachine.addExclusions(paths: exclusionsToAdd)
		TimeMachine.removeExclusions(paths: exclusionsToRemove)
		
		/* Update cache file. */
		cache.write(paths: exclusions)
		
		Tmignore.logger.info("Finished update")
	}
	
}
