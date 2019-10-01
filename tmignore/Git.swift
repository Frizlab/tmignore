import Foundation
import os.log

/**
	Class for Git operations
*/
class Git {
	/**
		Returns the list of ignored files for the specified Git repository (both local and global
		`.gitignore` files are considered)
	*/
	static func getIgnoredFiles(repoPath: String) -> [String] {
		os_log("Obtaining list of ignored files for repo at %s…", type: .debug, repoPath)
		var ignoredFiles = [String]()

		let command = "git -C \(repoPath) ls-files --directory --exclude-standard --ignored --others"
		let (status, stdout, stderr) = runCommand(command: command)

		if status != 0 {
			os_log(
				"Error obtaining list of ignored files for repository at path %s: %s",
				type: .error,
				repoPath,
				stderr ?? ""
			)
		} else {
			let ignoredFilesRel = splitLines(linesStr: stdout)
			ignoredFiles = ignoredFilesRel.map { "\(repoPath)/\($0)" }
		}

		os_log("Found %d ignored files for repo at %s", type: .debug, ignoredFiles.count, repoPath)
		return ignoredFiles
	}

	/**
		Searches the home directory for Git repositories and returns their paths. Folders specified
		in `ignoredPaths` aren't traversed
	*/
	static func findRepos(ignoredPaths: [String]) -> [String] {
		var repoPaths = [String]()
		os_log("Searching for Git repositories…")

		// Start building array of arguments for the `find` command
		var command = "find $HOME"

		// Tell `find` to skip the ignored paths
		for ignoredPath in ignoredPaths {
			command += " -path \(ignoredPath) -prune -o"
		}

		// Add the remaining `find` arguments
		// "-type d": Only search directories
		// "-name .git": Only search for files/directories named ".git"
		// "-print": Print the results
		command += " -type d -name .git -print"

		// Run the `find` command
		let (status, stdout, stderr) = runCommand(command: command)
		if status != 0 {
			for errLine in splitLines(linesStr: stderr) {
				if !errLine.hasSuffix("Operation not permitted") {
					os_log("Error searching for Git repositories: %s", type: .error, errLine)
				}
			}
		}

		// Build list of `.git` directories (e.g. ["/path/to/repo/.git"])
		let gitDirs = splitLines(linesStr: stdout)

		// Build list of repositories (e.g. ["/path/to/repo"])
		repoPaths = gitDirs.map {
			String($0.dropLast(5)).replacingOccurrences(of: " ", with: "\\ ")
		}

		os_log("Found %d Git repositories", repoPaths.count)
		return repoPaths
	}
}