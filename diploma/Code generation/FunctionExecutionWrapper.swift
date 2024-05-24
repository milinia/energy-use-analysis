//
//  FunctionExecutionWrapper.swift
//  diploma
//
//  Created by Evelina on 27.04.2024.
//

import Foundation
import SwiftSyntax
import SwiftParser
import Files

class FunctionExecutionWrapper {

    func processFile(file: DFile) -> DFile? {
        guard let fileContent = String(data: file.data, encoding: .utf8) else {return nil}
        let syntaxTree = Parser.parse(source: fileContent)
        let syntaxVisitor = FunctionCallHandler(viewMode: .fixedUp)
        syntaxVisitor.file = file
        syntaxVisitor.walk(syntaxTree)
        if syntaxVisitor.isTestingFile {
            return file
        } else {
            return syntaxVisitor.file
        }
    }
}

class FunctionCallHandler: SyntaxVisitor {
    private var argumentsList: Array<(Int, Int)> = []
    private var functionsList: Array<(Int, Int)> = []
    private var conditionList: Dictionary<Int, Int> = [:]
    private var count: Int = 1
    private var argumentCount: Int = 1
    private var returnCount: Int = 1
    private var offset: Int = 0
    var isTestingFile: Bool = false
    var file: DFile?
    
    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if isTestingFile {
            return .skipChildren
        } else {
            if !(node.calledExpression.description.first?.isUppercase ?? true) && !(node.parent?.description.contains("fatalError") ?? true) && !(node.parent?.description.contains("super") ?? true) && !(node.parent?.description.contains(".success") ?? true) && !(node.parent?.description.contains(".failure") ?? true) && !(node.parent?.description.contains("DispatchQueue") ?? true) &&
                ((node.parent?.as(ArrayElementSyntax.self)) == nil) && !(node.description.contains("NSLayoutConstraint.activate")) &&
                !(node.description.contains("$0")) && !(node.description.contains(".contains(")) {
                let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
                var lineStart = source.start.line
                var lineEnd = source.end.line
                var isInsideFunctionExp: Bool = false
                for function in functionsList {
                    if function.0 <= lineStart && function.1 >= lineStart {
                        isInsideFunctionExp = true
                    }
                }
                if isInsideFunctionExp {
                    let columnStart = source.start.column
                    var startTime = "let startTime\(count) = Date()"
                    var endTime = "let endTime\(count) = Date()"
                    let functionName = node.calledExpression.description.replacingOccurrences(of: "\\s+", with: "", options: .regularExpression)
                    let timeName = "timeInterval\(count)"
                    var saveToFileFunctionCall = "SaveData.writeToFile(file: .functionsTimeFile, text: \"\(file?.path ?? "") \(lineStart) \(functionName) \\(Thread.current.isMainThread) \\(endTime\(count).timeIntervalSince(startTime\(count)))\")"
                    let offsetString = String(repeating: " ", count: columnStart - 1)
                    startTime.insert(contentsOf: offsetString, at: startTime.startIndex)
                    endTime.insert(contentsOf: offsetString, at: endTime.startIndex)
                    saveToFileFunctionCall.insert(contentsOf: offsetString, at: saveToFileFunctionCall.startIndex)
                    var isLabeledExp: Bool = false
                    for argument in argumentsList {
                        if argument.0 <= lineStart && argument.1 >= lineStart {
                            lineStart = argument.0
                            lineEnd = argument.1
                            isLabeledExp = true
                        }
                    }
                    if (node.parent?.description.contains("return") ?? true) { //функция вызывается вместе с return
                        var setValueLine = "let returnVar\(returnCount) = \(node.description)"
                        setValueLine.insert(contentsOf: offsetString, at: setValueLine.startIndex)
                        var originalLine = file?.lines[lineStart - 1 + offset]
                        let newLine = originalLine?.replacingOccurrences(of: node.description, with: "returnVar\(returnCount) ")
                        file?.lines[lineStart - 1 + offset] = newLine ?? ""
                        file?.lines.insert(setValueLine, at: lineStart - 1 + offset)
                        lineStart = lineStart - 1
                        lineEnd = lineEnd - 1
                        offset += 1
                        returnCount += 1
                        file?.lines.insert(startTime, at: lineStart - 1 + offset)
                        file?.lines.insert(saveToFileFunctionCall, at: lineEnd + offset + 1)
                        file?.lines.insert(endTime, at: lineEnd + offset + 1)
                    } else if (((node.parent?.as(LabeledExprSyntax.self)) != nil) || isLabeledExp || (conditionList[lineStart] != nil)) {
                        var setValueLine = "let argumentVar\(argumentCount) = \(node.description)"
                        setValueLine.insert(contentsOf: offsetString, at: setValueLine.startIndex)
                        var originalLine = file?.lines[source.start.line - 1 + offset]
                        let newLine = originalLine?.replacingOccurrences(of: node.description, with: "argumentVar\(argumentCount) ")
                        file?.lines[source.start.line - 1 + offset] = newLine ?? ""
                        file?.lines.insert(setValueLine, at: lineStart - 1 + offset)
                        lineStart = lineStart - 1
                        lineEnd = lineEnd - 1
                        argumentCount += 1
                        offset += 1
                        file?.lines.insert(startTime, at: lineStart - 1 + offset)
                        file?.lines.insert(saveToFileFunctionCall, at: lineStart + offset + 1)
                        file?.lines.insert(endTime, at: lineStart + offset + 1)
                    } else {
                        file?.lines.insert(startTime, at: lineStart - 1 + offset)
                        file?.lines.insert(saveToFileFunctionCall, at: lineEnd + offset + 1)
                        file?.lines.insert(endTime, at: lineEnd + offset + 1)
                    }
                    offset += 3
                    count += 1
                }
            }
        }
        return .visitChildren
    }
    
    override func visit(_ node: LabeledExprListSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
        let start = source.start.line
        let end = source.end.line
        argumentsList.append((start, end))
        return .visitChildren
    }

    override func visit(_ node: ConditionElementSyntax) -> SyntaxVisitorContinueKind {
        if node.description.contains("=")  {
            let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
            conditionList[source.start.line] = source.end.line
        }
        return .visitChildren
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        let source = node.sourceRange(converter: SourceLocationConverter(fileName: file?.path.relativePath ?? "", tree: node.root))
        functionsList.append((source.start.line, source.end.line))
        return .visitChildren
    }
    
    override func visit(_ node: ImportDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.description.contains("@testable") {
            isTestingFile = true
            return .skipChildren
        }
        return .visitChildren
    }
}
