//
//  ErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 02.04.2024.
//

import Foundation
import SwiftSyntax
import SwiftParser

class ErrorCorrector {
    
    func correctErrors(errors: [MetricErrorData], project: Project) {
        for error in errors {
            correctError(error: error)
        }
    }
    
    func findClass(with name: String, project: Project) -> DFile? { //Core Motion, Bluetooth, Location используют систему делегатов
        var contents = project.content
        while(!contents.isEmpty) {
            guard let content = contents.first else {return nil}
            switch content {
            case let dfile as DFile:
                let name = dfile.path.relativePath ?? ""
                if dfile.path.hasSuffix(".swift") {
                    guard let fileContent = String(data: dfile.data, encoding: .utf8) else {return nil}
                    let syntaxTree = Parser.parse(source: fileContent)
                    let syntaxVisitor = ClassFindVisitor(viewMode: .fixedUp)
                    syntaxVisitor.className = name
                    syntaxVisitor.walk(syntaxTree)
                    if syntaxVisitor.isClassFinded {
                        return dfile
                    }
                }
            case let dfolder as DFolder:
                contents.append(contentsOf: dfolder.сontent)
            default:
                break
            }
        }
        return nil
    }
    
    func correctError(error: MetricErrorData) {
        switch error.type {
        case is Location: break
        case is TimerError: break
        case is Bluetooth: break
        case is Motion: break
        case is Brightness: break
        case is Reaction: break
        case is Cashing: break
        case is QualityOfService: break
        case is RetryDelay: break
        case is ComputeTask: break
        default: break
        }
    }
}

class ClassFindVisitor: SyntaxVisitor {
    var isClassFinded: Bool = false
    var file: DFile?
    var className: String = ""
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.name.text == className {
            isClassFinded = true
        }
        return .visitChildren
    }
}
