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
    var fileName: String = ""
    
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: fileName, tree: node.root))
        classNames.append(ClassInfo(name: node.name.text,
                                    startLine: source.start.line,
                                    endLine: source.end.line))
        return .visitChildren
    }
}

struct ClassInfo {
    let name: String
    let startLine: Int
    let endLine: Int
}
