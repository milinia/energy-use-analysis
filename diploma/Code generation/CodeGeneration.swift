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
    
    func generate(project: Project) {
        do {
            let projectFolder = try Folder(path: project.path.relativePath)
            let testFolder = try projectFolder.createSubfolder(named: "Test")
            let path = testFolder.path
            FileSaver.createFile(content: [], path: path, name: FileName.functionsTimeFile.rawValue)
            FileSaver.createFile(content: [], path: path, name: FileName.calledFunctionFile.rawValue)
            FileSaver.createFile(content: [], path: path, name: "SaveData.swift")
            FileSaver.createFile(content: getSaveDataClass(path: path), path: path, name: "SaveData.swift")
            FileSaver.createFile(content: getScriptFileData(), path: path, name: "script.sh")
            let contents = project.content
            for content in contents {
                switch content {
                case let dfile as DFile:
                    let name = dfile.path.relativePath ?? ""
                    if dfile.path.hasSuffix(".swift") {
                        var generatedContent = functionExecutionWrapper.processFile(file: dfile)
                        if dfile.path.contains("AppDelegate")  {
                            generatedContent = addCodeToAppDelegateClass(file: generatedContent)
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
    
    private func getScriptFileData() -> [String]{
        do {
            let file = try File(path: "/Users/milinia/Documents/energy-use-analysis/diploma/Code generation/script.sh")
            let data = try file.read()
            var lines = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines) ?? []
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
                    let generatedContent = functionExecutionWrapper.processFile(file: dfile)
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
    
    override func visit(_ node: ImportDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
        file?.lines.insert("import SwiftTrace", at: source.start.line)
        return .skipChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
        if ((file?.lines[source.start.line].contains("func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool")) != nil) {
            file?.lines.insert("SwiftTrace.trace(aClass: UIScreen.self)", at: source.end.line - 1)
            file?.lines.insert("SwiftTrace.trace(aClass: UIViewController.self)", at: source.end.line - 1)
            file?.lines.insert("SwiftTrace.trace(aClass: NotificationCenter.self)", at: source.end.line - 1)
            file?.lines.insert("SwiftTrace.trace(aClass: CBCentralManager.self)", at: source.end.line - 1)
            file?.lines.insert("SwiftTrace.trace(aClass: CMMotionManager.self)", at: source.end.line - 1)
            file?.lines.insert("SwiftTrace.trace(aClass: CLLocationManager.self)", at: source.end.line - 1)
            file?.lines.insert("SwiftTrace.swizzleFactory = MyTracer.self", at: source.end.line - 1)
        }
        return .skipChildren
    }
}
