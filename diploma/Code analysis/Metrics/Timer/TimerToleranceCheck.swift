//
//  TimerToleranceCheck.swift
//  diploma
//
//  Created by Evelina on 16.03.2024.
//

import Foundation
import SwiftSyntax

class TimerToleranceCheck: SyntaxVisitor {
    var timerVariableNames = Dictionary<String, (Bool, ErrorRange)>()
    var errors: [MetricErrorData] = []
    var file: DFile?
        
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if node.description.contains("Timer") {
            let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
            if let line = file?.lines[source.start.line] {
                if line.contains("=") {
                    let pattern = "(?:let|var)?\\s*(\\w+)\\s*=\\s*Timer\\("
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
                    timerVariableNames[varName] = (false, ErrorRange(start: source.start.line,
                                                                     end: source.end.line))
                } else {
                    if let nonOptionalFile = file {
                        errors.append(MetricErrorData(type: TimerError.timerTolerace,
                                                      range: ErrorRange(start: source.start.line, end: source.end.line),
                                                      file: nonOptionalFile, canFixError: true))
                    }
                }
            }
        }
        return .visitChildren
    }
     
    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        if let key = node.base?.as(DeclReferenceExprSyntax.self)?.baseName.text, let value = timerVariableNames[key] {
            if node.declName.baseName.text == "tolerance"  {
                timerVariableNames[key]?.0 = true
            }
        }
        return .visitChildren
    }
}
