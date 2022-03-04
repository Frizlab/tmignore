import Foundation

import ArgumentParser
import HeliumLogger
import Logging



let logger: Logger = {
	/* Set up Helium logger. */
	let heliumLogger = HeliumLogger()
	heliumLogger.colored = true
	heliumLogger.format = "(%msg)"
	
	/* Configure swift-log to use Helium backend. */
	LoggingSystem.bootstrap(heliumLogger.makeLogHandler)
	return Logger(label: "me.frizlab.tmignore")
}()

@main
struct Tmignore : ParsableCommand {
	
	static var configuration: CommandConfiguration = .init(
		abstract: "Exclude development files from Time Machine backups",
		version: "1.2.2",
		subcommands: [
			Run.self,
			List.self,
			Reset.self
		]
	)
	
}
