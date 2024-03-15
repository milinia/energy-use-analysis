//
//  FileTraverser.swift
//  diploma
//
//  Created by Evelina on 18.01.2024.
//

import SwiftSyntax
import SwiftParser

final class FileTraverser {

    func traverseFile(file: File) -> SourceFileSyntax? {
        guard let fileContent = String(data: file.data, encoding: .utf8) else {return nil}
        let syntaxTree = Parser.parse(source: fileContent)
//        let syntaxVisitor = NodesTraverser(viewMode: .fixedUp)
//        syntaxVisitor.walk(syntaxTree)
        let syntaxVisitor = QoSDispatchQueueGlobalCheck(viewMode: .fixedUp)
        syntaxVisitor.walk(syntaxTree)
        return syntaxTree
    }
}