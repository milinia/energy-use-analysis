//
//  ProjectReader.swift
//  diploma
//
//  Created by Evelina on 06.12.2023.
//

import Foundation
import Files

protocol ProjectReader {
    func readProject(projectPath: URL) throws -> (Project, [File])
}

class ProjectReaderImpl: ProjectReader {
    
    private let fileManager: FileManager
    private var projectFiles: [File] = []
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    func readProject(projectPath: URL) throws -> (Project, [File]) {
        do {
            let files = try Folder(path: projectPath.path()).files
            let folders = try Folder(path: projectPath.path()).subfolders
            var projectContent: [Content] = []
            for file in files {
                let fileContent = try file.read()
                let projectFile = File(path: file.path, type: .swift, data: fileContent)
                projectFiles.append(projectFile)
                projectContent.append(projectFile)
            }
            for folder in folders {
                projectContent.append(try getProjectFolder(path: folder.path))
            }
            return (Project(name: projectPath.lastPathComponent, content: projectContent, path: projectPath), projectFiles)
        } catch {
            throw AppError.noSuchFolder
        }
    }
    
    private func getProjectFolder(path: String) throws -> DFolder {
        do {
            let rootFolder = try Folder(path: path)
            let files = rootFolder.files
            let folders = rootFolder.subfolders
            
            var folderContent: [Content] = []
            for file in files {
                let fileContent = try file.read()
                let projectFile = File(path: file.path, type: .swift, data: fileContent)
                projectFiles.append(projectFile)
                folderContent.append(projectFile)
            }
            for folder in folders {
                folderContent.append(try getProjectFolder(path: folder.path))
            }
            let projectFolder = DFolder(path: path, content: folderContent)
            return projectFolder
        } catch {
            throw AppError.noSuchFolder
        }
    }
    
    private func isFolder(path: String) -> Bool {
        var isDirectory: ObjCBool = true
        return fileManager.fileExists(atPath: path, isDirectory: &isDirectory) && isDirectory.boolValue
    }
}
