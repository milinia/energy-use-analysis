//
//  ClassWalker.swift
//  diploma
//
//  Created by Evelina on 20.05.2024.
//

import Foundation
import SwiftSyntax

class ClassWalker: SyntaxVisitor {
    var classNames: [ClassInfo] = []
    var protocolNames: [ProtocolInfo] = []
    var projectFunctions: Dictionary<String, [ClassInfo]> = [:]
    var inheritanceAndImplementation: Dictionary<String, [String]> = [:]
    var file: DFile?
    
    private var regexChecker = RegexCheckerImpl()
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file!.path.relativePath ?? "", tree: node.root))
        classNames.append(ClassInfo(name: node.name.text,
                                    startLine: source.start.line,
                                    endLine: source.end.line, file: file!))
        return .visitChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file!.path.relativePath ?? "", tree: node.root))
        let classInfo = ClassInfo(name: file!.path.relativePath ?? "", startLine: source.start.line, endLine: source.end.line, file: file!)
        if (projectFunctions[node.name.text] != nil) {
            projectFunctions[node.name.text]?.append(classInfo)
        } else {
            projectFunctions[node.name.text] = [classInfo]
        }
        return .visitChildren
    }
    
    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file!.path.relativePath ?? "", tree: node.root))
        protocolNames.append(ProtocolInfo(name: node.name.text,
                                    startLine: source.start.line,
                                    endLine: source.end.line, file: file!))
        return .visitChildren
    }
    
    override func visit(_ node: InheritedTypeSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file!.path.relativePath ?? "", tree: node.root))
        let pattern = #"\b(?:extension|class|struct)\s+(\w+)"#
        if let line = file?.lines[source.start.line], let range = regexChecker.checkStringRegexRange(pattern: pattern, string: line) {
            let className = (line as NSString).substring(with: range)
            if (inheritanceAndImplementation[node.type.description] != nil) {
                inheritanceAndImplementation[node.type.description]?.append(className)
            } else {
                inheritanceAndImplementation[node.type.description] = [className]
            }
        }
        return .visitChildren
    }
}

struct ClassInfo {
    let name: String
    let startLine: Int
    let endLine: Int
    let file: DFile
}

struct ProtocolInfo {
    let name: String
    let startLine: Int
    let endLine: Int
    let file: DFile
}
