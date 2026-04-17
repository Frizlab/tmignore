import Foundation

import ArgumentParser
import HeliumLogger
import Logging



@main
struct Tmignore : ParsableCommand {
	
	static let configuration: CommandConfiguration = .init(
		commandName: "tmignore",
		abstract: "Exclude development files from Time Machine backups",
		version: "dev", /* DO NOT REMOVE: VERSION_PLACEHOLDER. This tag is used to automatically replace the version when building in Homebrew. */
		subcommands: [
			Run.self,
			List.self,
			Reset.self
		]
	)
	
	static let logger: Logger = {
		/* Set up Helium logger. */
		let heliumLogger = HeliumLogger()
		heliumLogger.colored = true
		heliumLogger.format = "(%msg)"
		
		/* Configure swift-log to use Helium backend. */
		LoggingSystem.bootstrap(heliumLogger.makeLogHandler)
		return Logger(label: "me.frizlab.tmignore")
	}()
	
}
