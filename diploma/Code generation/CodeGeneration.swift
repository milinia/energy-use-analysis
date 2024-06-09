//
//  CodeGeneration.swift
//  diploma
//
//  Created by Evelina on 23.04.2024.
//

import Foundation
import Files
import SwiftSyntax
import SwiftParser

enum FileName: String {
    case functionsTimeFile = "time.text"
    case calledFunctionFile = "runtime.text"
}


class CodeGeneration {
    // добавить класс для отслеживания метрик и записи в файл
    // добавить код в AppDelegate или @main
    // добавить отслеживание времени выполнения каждой функции
    
    private let functionExecutionWrapper: FunctionExecutionWrapper = FunctionExecutionWrapper()
    private let regexChecker = RegexCheckerImpl()
    private var isAppDelegateAdded = false
    private var isPodProject = false
    
    func generate(project: Project, projectInfo: ProjectInfo) {
        do {
            let projectFolder = try Folder(path: project.path.relativePath)
            if let podfile = projectInfo.projectFiles.filter({$0.path.relativePath == "Podfile"}).first {
                isPodProject = true
            }
            let testFolder = try projectFolder.createSubfolder(named: "Test")
            let path = testFolder.path
            FileSaver.createFile(content: [], path: path, name: FileName.functionsTimeFile.rawValue)
            FileSaver.createFile(content: [], path: path, name: FileName.calledFunctionFile.rawValue)
            FileSaver.createFile(content: getScriptFileData(), path: path, name: "script.sh")
            let projectCopy = project.copy()
            if let projectCopy = projectCopy as? Project {
                let contents = projectCopy.content
                for content in contents {
                    switch content {
                    case let dfile as DFile:
                        let name = dfile.path.relativePath ?? ""
                        if dfile.path.hasSuffix(".swift") {
                            var generatedContent = functionExecutionWrapper.processFile(file: dfile)
                            if dfile.path.contains("AppDelegate") && !isAppDelegateAdded {
                                isAppDelegateAdded = true
                                generatedContent = addCodeToAppDelegateClass(file: generatedContent)
                            }
                            FileSaver.createFile(content: generatedContent?.lines ?? [], path: path, name: name)
                        } else {
                            FileSaver.createFile(content: dfile.lines, path: path, name: name)
                        }
                    case let dfolder as DFolder:
                        if isPodProject && (dfolder.path.relativePath == "Pods") {
                            copyFolderContent(path: path, folder: dfolder)
                        } else {
                            getFolderContent(path: path, folder: dfolder)
                        }
                    default:
                        break
                    }
                }
                FileSaver.createFile(content: [], path: path + project.name, name: "SaveData.swift")
                FileSaver.createFile(content: getSaveDataClass(path: path), path: path + project.name, name: "SaveData.swift")
                
                FileSaver.createFile(content: [], path: path + project.name, name: "MyTracer.swift")
                FileSaver.createFile(content: getMyTracerClass(), path: path + project.name, name: "MyTracer.swift")
            }
        } catch {
            
        }
    }
    
    private func getSaveDataClass(path: String) -> [String]{
        do {
            let file = try File(path: "/Users/milinia/Documents/energy-use-analysis/diploma/Code generation/SaveData.txt")
            let data = try file.read()
            var lines = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines) ?? []
            lines[9].append(" \"\(path)\"")
            return lines
        } catch {
            
        }
        return []
    }
    
    private func getMyTracerClass() -> [String]{
        do {
            let file = try File(path: "/Users/milinia/Documents/energy-use-analysis/diploma/Code generation/Tracer.txt")
            let data = try file.read()
            let lines = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines) ?? []
            return lines
        } catch {
            
        }
        return []
    }
    
    private func getScriptFileData() -> [String]{
        do {
            let file = try File(path: "/Users/milinia/Documents/energy-use-analysis/diploma/Code generation/script.sh")
            let data = try file.read()
            let lines = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines) ?? []
            return lines
        } catch {
            
        }
        return []
    }
    
    private func addCodeToAppDelegateClass(file: DFile?) -> DFile? {
        if let file = file {
            guard let fileContent = String(data: file.data, encoding: .utf8) else {return nil}
            let syntaxTree = Parser.parse(source: fileContent)
            let syntaxVisitor = AppDelegateWalker(viewMode: .fixedUp)
            syntaxVisitor.file = file
            syntaxVisitor.walk(syntaxTree)
            return syntaxVisitor.file
        } else {
            return file
        }
    }
    
    private func copyFolderContent(path: String, folder: DFolder) {
        do {
            let contents = folder.сontent
            let folderName: String = folder.path.relativePath ?? ""
            let folder = try Folder(path: folder.path)
            FileSaver.createFolder(path: path, name: folder.path.relativePath ?? "")
            let testPodsFolder = try Folder(path: path + "/" + folderName)
            try folder.copy(to: testPodsFolder)
        } catch {
            
        }
//        FileSaver.createFolder(path: path, name: folder.path.relativePath ?? "")
//        let path = path + "/" + folderName
//        for content in contents {
//            switch content {
//            case let dfile as DFile:
//                let name = dfile.path.relativePath ?? ""
//                if dfile.path.hasSuffix(".swift") {
//                    var generatedContent = functionExecutionWrapper.processFile(file: dfile)
//                    if dfile.path.contains("AppDelegate") && !isAppDelegateAdded {
//                        generatedContent = addCodeToAppDelegateClass(file: generatedContent)
//                        isAppDelegateAdded = true
//                    }
//                    FileSaver.createFile(content: generatedContent?.lines ?? [], path: path, name: name)
//                } else {
//                    FileSaver.createFile(content: dfile.lines, path: path, name: name)
//                }
//            case let dfolder as DFolder:
//                getFolderContent(path: path, folder: dfolder)
//            default:
//                break
//            }
//        }
    }
    
    private func getFolderContent(path: String, folder: DFolder) {
        let contents = folder.сontent
        FileSaver.createFolder(path: path, name: folder.path.relativePath ?? "")
        let folderName: String = folder.path.relativePath ?? ""
        let path = path + "/" + folderName
        for content in contents {
            switch content {
            case let dfile as DFile:
                let name = dfile.path.relativePath ?? ""
                if dfile.path.hasSuffix(".swift") {
                    var generatedContent = functionExecutionWrapper.processFile(file: dfile)
                    if dfile.path.contains("AppDelegate") && !isAppDelegateAdded {
                        generatedContent = addCodeToAppDelegateClass(file: generatedContent)
                        isAppDelegateAdded = true
                    }
                    FileSaver.createFile(content: generatedContent?.lines ?? [], path: path, name: name)
                } else {
                    FileSaver.createFile(content: dfile.lines, path: path, name: name)
                }
            case let dfolder as DFolder:
                getFolderContent(path: path, folder: dfolder)
            default:
                break
            }
        }
    }
}

class AppDelegateWalker: SyntaxVisitor {
    var file: DFile?
    var isCodeAdded: Bool = false
    
    override func visit(_ node: ImportDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
        file?.lines.insert("import SwiftTrace", at: source.start.line)
        file?.lines.insert("import CoreLocation", at: source.start.line)
        file?.lines.insert("import CoreMotion", at: source.start.line)
        file?.lines.insert("import CoreBluetooth", at: source.start.line)
        return .skipChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
        if ((file?.lines[source.start.line].contains("func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool")) != nil) && !isCodeAdded {
            let offset = file?.lines[source.end.line + 2].spaceFromLineStart ?? 0
            let offsetString = String(repeating: " ", count: offset)
            file?.lines.insert(offsetString + "SwiftTrace.trace(aClass: UIScreen.self)", at: source.end.line + 2)
            file?.lines.insert(offsetString + "SwiftTrace.trace(aClass: UIViewController.self)", at: source.end.line + 2)
            file?.lines.insert(offsetString + "SwiftTrace.trace(aClass: NotificationCenter.self)", at: source.end.line + 2)
            file?.lines.insert(offsetString + "SwiftTrace.trace(aClass: CBCentralManager.self)", at: source.end.line + 2)
            file?.lines.insert(offsetString + "SwiftTrace.trace(aClass: CMMotionManager.self)", at: source.end.line + 2)
            file?.lines.insert(offsetString + "SwiftTrace.trace(aClass: CLLocationManager.self)", at: source.end.line + 2)
            file?.lines.insert(offsetString + "SwiftTrace.swizzleFactory = MyTracer.self", at: source.end.line + 2)
            isCodeAdded = true
        }
        return .skipChildren
    }
}
