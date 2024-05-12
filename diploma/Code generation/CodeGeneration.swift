//
//  CodeGeneration.swift
//  diploma
//
//  Created by Evelina on 23.04.2024.
//

import Foundation
import Files

enum FileName: String {
    case functionsTimeFile = "time.text"
    case calledFunctionFile = "runtime.text"
}


class CodeGeneration {
    // добавить класс для отслеживания метрик и записи в файл
    // добавить код в AppDelegate или @main
    // добавить отслеживание времени выполнения каждой функции
    
    let functionExecutionWrapper: FunctionExecutionWrapper = FunctionExecutionWrapper()
    
    func generate(project: Project) {
        do {
            let projectFolder = try Folder(path: project.path.relativePath)
            let testFolder = try projectFolder.createSubfolder(named: "Test")
            let path = testFolder.path
            FileSaver.createFile(content: [], path: path, name: FileName.functionsTimeFile.rawValue)
            FileSaver.createFile(content: [], path: path, name: FileName.calledFunctionFile.rawValue)
            FileSaver.createFile(content: [], path: path, name: "SaveData.swift")
            FileSaver.createFile(content: getNewClass(path: path), path: path, name: "SaveData.swift")
            let contents = project.content
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
        } catch {
            
        }
    }
    
    private func getNewClass(path: String) -> [String]{
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
