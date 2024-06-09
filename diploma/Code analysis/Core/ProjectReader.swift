//
//  ProjectReader.swift
//  diploma
//
//  Created by Evelina on 06.12.2023.
//

import Foundation
import Files
import SwiftParser

protocol ProjectReader {
    func readProject(projectPath: URL) throws -> (Project, ProjectInfo)
}

class ProjectInfo {
    let projectFiles: [DFile]
    let classNames: [ClassInfo]
    let protocolNames: [ProtocolInfo]
    let projectFunctions: Dictionary<String, [ClassInfo]>
    let inheritanceAndImplementation: Dictionary<String, [String]>
    var delegates: Dictionary<String, [String]>
    
    init(projectFiles: [DFile], classNames: [ClassInfo], protocolNames: [ProtocolInfo], projectFunctions: Dictionary<String, [ClassInfo]>, inheritanceAndImplementation: Dictionary<String, [String]>) {
        self.projectFiles = projectFiles
        self.classNames = classNames
        self.protocolNames = protocolNames
        self.projectFunctions = projectFunctions
        self.inheritanceAndImplementation = inheritanceAndImplementation
        self.delegates = [:]
    }
}

class ProjectReaderImpl: ProjectReader {
    
    private var projectFiles: [DFile] = []
    private var projectName: String = ""
    private var swiftFilesSet: Set<DFile> = Set<DFile>()
    private var isPodProject = false
    
    func readProject(projectPath: URL) throws -> (Project, ProjectInfo) {
        do {
            let files = try Folder(path: projectPath.path()).files
            let folders = try Folder(path: projectPath.path()).subfolders
            var projectContent: [Content] = []
            for file in files {
                if let path = file.path.relativePath {
                    if path.contains(".xcodeproj") {
                        projectName = path.replacingOccurrences(of: ".xcodeproj", with: "")
                    }
                }
                if file.name == "Podfile" {
                    isPodProject = true
                }
                let fileContent = try file.read()
                let projectFile = DFile(path: file.path, type: .swift, data: fileContent)
                if projectFile.path.contains(".swift") {
                    swiftFilesSet.insert(projectFile)
                }
                projectFiles.append(projectFile)
                projectContent.append(projectFile)
            }
            for folder in folders {
                if folder.name == "Pods" && isPodProject {
                    
                } else {
                    projectContent.append(try getProjectFolder(path: folder.path))
                }
            }
            let info = getClassesInfo(files: projectFiles)
            return (Project(name: projectName, content: projectContent, path: projectPath), info)
        } catch {
            throw AppError.noSuchFolder
        }
    }
    
    private func getClassesInfo(files: [DFile]) -> ProjectInfo {
        var classNames: [ClassInfo] = []
        var protocolNames: [ProtocolInfo] = []
        var projectFunctions: Dictionary<String, [ClassInfo]> = [:]
        var inheritanceAndImplementation: Dictionary<String, [String]> = [:]
        while !swiftFilesSet.isEmpty {
            if let swiftFile = swiftFilesSet.popFirst() {
                if let fileContent = String(data: swiftFile.data, encoding: .utf8) {
                    let syntaxTree = Parser.parse(source: fileContent)
                    let syntaxVisitor = ClassWalker(viewMode: .fixedUp)
                    syntaxVisitor.file = swiftFile
                    syntaxVisitor.walk(syntaxTree)
                    classNames.append(contentsOf: syntaxVisitor.classNames)
                    protocolNames.append(contentsOf: syntaxVisitor.protocolNames)
                    syntaxVisitor.projectFunctions.keys.forEach { key in
                        if (projectFunctions[key] != nil) {
                            projectFunctions[key]?.append(contentsOf: syntaxVisitor.projectFunctions[key] ?? [])
                        } else {
                            projectFunctions[key] = syntaxVisitor.projectFunctions[key]
                        }
                    }
                    syntaxVisitor.inheritanceAndImplementation.keys.forEach { key in
                        if (inheritanceAndImplementation[key] != nil) {
                            inheritanceAndImplementation[key]?.append(contentsOf: syntaxVisitor.inheritanceAndImplementation[key] ?? [])
                        } else {
                            inheritanceAndImplementation[key] = syntaxVisitor.inheritanceAndImplementation[key]
                        }
                    }
                }
            }
        }
        return ProjectInfo(projectFiles: files, classNames: classNames, 
                           protocolNames: protocolNames,
                           projectFunctions: projectFunctions,
                           inheritanceAndImplementation: inheritanceAndImplementation)
    }
    
    private func getProjectFolder(path: String) throws -> DFolder {
        do {
            let rootFolder = try Folder(path: path)
            let files = rootFolder.files
            let folders = rootFolder.subfolders
            if let path = path.relativePath {
                if path.contains(".xcodeproj") {
                    projectName = path.replacingOccurrences(of: ".xcodeproj", with: "")
                }
            }
            
            var folderContent: [Content] = []
            for file in files {
                if let path = file.path.relativePath {
                    if path.contains(".xcodeproj") {
                        projectName = path.replacingOccurrences(of: ".xcodeproj", with: "")
                    }
                }
                if file.name == "Podfile" {
                    isPodProject = true
                }
                let fileContent = try file.read()
                let projectFile = DFile(path: file.path, type: .swift, data: fileContent)
                if projectFile.path.contains(".swift") {
                    swiftFilesSet.insert(projectFile)
                }
                projectFiles.append(projectFile)
                folderContent.append(projectFile)
            }
            for folder in folders {
                if folder.name == "Pods" && isPodProject {
                    
                } else {
                    folderContent.append(try getProjectFolder(path: folder.path))
                }
            }
            let projectFolder = DFolder(path: path, content: folderContent)
            return projectFolder
        } catch {
            throw AppError.noSuchFolder
        }
    }
}
