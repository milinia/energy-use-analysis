//
//  CacheURLRequestCachePolicyCheck.swift
//  diploma
//
//  Created by Evelina on 16.03.2024.
//

import Foundation
import SwiftSyntax

class CacheURLRequestCachePolicyCheck: SyntaxVisitor {
    var urlRequestVariableNames = Dictionary<String, (Bool, ErrorRange)>()
    let cachePolicyRegexPattern: String = ".+\\.(returnCacheDataElseLoad|returnCacheDataDontLoad|reloadRevalidatingCacheData)"
    let regexChecker: RegexChecker = RegexCheckerImpl()
    var file: DFile?
    private var linesURLRequestUse: Set<Int> = Set()
        
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.description.contains("URLRequest") {
            if let identifierPattern = node.bindings.first(where: { patternBindingSyntax in
                patternBindingSyntax.pattern.is(IdentifierPatternSyntax.self)
            })?.pattern.as(IdentifierPatternSyntax.self) {
                let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
                urlRequestVariableNames[identifierPattern.identifier.text] = (false, ErrorRange(start: source.start.line, end: source.end.line))
                linesURLRequestUse.insert(source.start.line)
            }
        }
        return .visitChildren
    }
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
        if linesURLRequestUse.contains(source.start.line) {
            let arguments = node.arguments
            for argument in arguments {
                if argument.label?.text == "cachePolicy" {
                    guard let line = file?.lines[source.start.line] else {return .visitChildren}
                    let pattern = "(?:let|var)?\\s*(\\w+)\\s*=\\s*URLRequest\\("
                    var varName = ""
                    do {
                        let regex = try NSRegularExpression(pattern: pattern, options: [])
                        if let match = regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) {
                            if let range = Range(match.range(at: 1), in: line) {
                                varName =  String(line[range])
                            }
                        }
                    } catch {
                        
                    }
                    urlRequestVariableNames.removeValue(forKey: varName)
                }
            }
        }
        return .visitChildren
    }
     
    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        if let key = node.base?.as(DeclReferenceExprSyntax.self)?.baseName.text, let value = urlRequestVariableNames[key] {
            if node.declName.baseName.text == "cachePolicy"  {
                if let sourceCode = node.parent?.description {
                    if regexChecker.checkStringRegex(pattern: cachePolicyRegexPattern, string: sourceCode) {
                        urlRequestVariableNames[key]?.0 = true
                    }
                }
            }
        }
        return .visitChildren
    }
}
