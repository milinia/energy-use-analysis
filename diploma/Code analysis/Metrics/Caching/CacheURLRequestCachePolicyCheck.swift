//
//  CacheURLRequestCachePolicyCheck.swift
//  diploma
//
//  Created by Evelina on 16.03.2024.
//

import Foundation
import SwiftSyntax

class CacheURLRequestCachePolicyCheck: SyntaxVisitor {
    var urlRequestVariableNames = Dictionary<String, Bool>()
    let cachePolicyRegexPattern: String = ".+\\.(returnCacheDataElseLoad|returnCacheDataDontLoad|reloadRevalidatingCacheData)"
    let regexChecker: RegexChecker = RegexCheckerImpl()
        
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.description.contains("URLRequest") {
            if let identifierPattern = node.bindings.first(where: { patternBindingSyntax in
                patternBindingSyntax.pattern.is(IdentifierPatternSyntax.self)
            })?.pattern.as(IdentifierPatternSyntax.self) {
                urlRequestVariableNames[identifierPattern.identifier.text] = false
            }
        }
        return .visitChildren
    }
     
    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        if let key = node.base?.as(DeclReferenceExprSyntax.self)?.baseName.text, let value = urlRequestVariableNames[key] {
            if node.declName.baseName.text == "cachePolicy"  {
                if let sourceCode = node.parent?.description {
                    if regexChecker.checkStringRegex(pattern: cachePolicyRegexPattern, string: sourceCode) {
                        urlRequestVariableNames[key] = true
                    }
                }
            }
        }
        return .visitChildren
    }
}
