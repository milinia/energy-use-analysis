//
//  ComputeTaskErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation
import Files
import SwiftSyntax
import SwiftParser

class ComputeTaskErrorCorrector {
    
    var projectFunctions: Dictionary<String, [ClassInfo]>
    var classes: Dictionary<String, ClassInfo> = [:]
    var protocols: Dictionary<String, ProtocolInfo> = [:]
    var inheritanceAndImplementation: Dictionary<String, [String]> = [:]
    var argumentsCount: Dictionary<String, Int> = [:]
    var fileOffset: Dictionary<String, Int> = [:]
    var projectFiles: [DFile]
    
    private var uikitClasses: Set<String> = Set<String>()
    private let regexChecker: RegexChecker = RegexCheckerImpl()
    
    init(projectFunctions: Dictionary<String, [ClassInfo]>, classes: Dictionary<String, ClassInfo>, 
         protocols: Dictionary<String, ProtocolInfo>, projectFiles: [DFile],
         inheritanceAndImplementation: Dictionary<String, [String]> = [:]) {
        self.projectFunctions = projectFunctions
        self.classes = classes
        self.protocols = protocols
        self.projectFiles = projectFiles
        self.inheritanceAndImplementation = inheritanceAndImplementation
    }
    
    func correct(function: FunctionExecutionTime) {
        uikitClasses = getUIClasses()
        if !checkFunctionBody(function: function) {
            if !function.isOnMainThread {
                // предложение вынести c BGBackgroundTaskRequest
            } else {
                // вынесение с DispatchQueue.global(.userInitiated).async {}
                if let file = projectFiles.filter({$0.path == function.path}).first {
                    let line = file.lines[function.line]
                    let patternOriginalCall = function.functionCall + #"\(.*?\)"#
                    guard let originalCallRange = regexChecker.checkStringRegexRange(pattern: patternOriginalCall, string: line) else {return}
                    let originalFunctionCall = (line as NSString).substring(with: originalCallRange)
                    let spaceFromLineStart = line.spaceFromLineStart
                    let dispatchQueueLineStart = String(repeating: "", count: spaceFromLineStart) + "DispatchQueue.global(qos: .userInitiated).async {"
                    let dispatchQueueLineEnd = String(repeating: "", count: spaceFromLineStart) + "}"
                    let pattern = #"\w+\(.*?\w*: "# + function.functionCall + #"\(.*?\).*?\)"#
                    var offset = 0
                    if (fileOffset[file.path] != nil) {
                        offset = fileOffset[file.path] ?? 0
                    } else {
                        fileOffset[file.path] = 0
                    }
                    if line.contains("=") ||  line.contains("return") || regexChecker.checkStringRegex(pattern: pattern, string: line) {
                        var count = 0
                        if let prevCount = argumentsCount[file.path] {
                            count = prevCount + 1
                            argumentsCount[file.path] = count
                        } else {
                            argumentsCount[file.path] = 1
                            count = 1
                        }
                        let argumentLine = String(repeating: "", count: spaceFromLineStart + 4) + "let argument\(count) = \(originalFunctionCall)"
                        file.lines.insert(dispatchQueueLineEnd, at: function.line + offset)
                        file.lines.insert(argumentLine, at: function.line + offset)
                        file.lines.insert(dispatchQueueLineStart, at: function.line + offset)
                        file.lines[function.line + 3 + offset] = line.replacingOccurrences(of: originalFunctionCall, with: "argument\(count)")
                        fileOffset[file.path] = offset + 3
                    } else {
                        file.lines.insert(dispatchQueueLineStart, at: function.line + offset)
                        file.lines.insert(dispatchQueueLineEnd, at: function.line + 2 + offset)
                        fileOffset[file.path] = offset + 2
                    }
                }
            }
        } else {
            // alert! очень затратная ui функция
        }
    }
    
    private func getUIClasses() -> Set<String> {
        var classes = Set<String>()
        do {
            let file = try File(path: "/Users/milinia/Documents/energy-use-analysis/diploma/Code correction/Core/UIKitClasses.txt")
            let data = try file.read()
            let text = String(data: data, encoding: .utf8)
            if let lines = text?.split(separator: "\n") {
                for line in lines {
                    classes.insert(String(line))
                }
            }
        } catch {
            
        }
        return classes
    }
    
    private func checkFunctionBody(function: FunctionExecutionTime) -> Bool {
        var functionClass: ClassInfo? = nil
        if function.functionCall.contains(".") {
            //  не в этом классе
            let parts = function.functionCall.split(separator: ".")
            if let file = projectFiles.filter({$0.path == function.path}).first {
                let pattern = "\\b(?:let|var)\\s+\(parts[0])\\b"
                let matches = regexChecker.checkTextRegex(pattern: pattern, text: String(data: file.data, encoding: .utf8) ?? "")
                var varType = ""
                for match in matches {
                    if !file.lines[match].starts(with: "//") {
                        // те мы сейчас вытаскиваем название класса/протокола
                        if file.lines[match].contains("=") {
                            // может быть как класс, так и протокол
                            // если протокол - привет проблемы -> где найти реализацию?
                            // если класс - легко найти -> находим нужный класс и у него проверяем тело функции
                            let typePattern = #"(?<=: )\w+"#
                            let string = file.lines[match]
                            if let range = regexChecker.checkStringRegexRange(pattern: typePattern, string: file.lines[match]) {
                                varType = (string as NSString).substring(with: range)
                                if let classInfo = classes[varType] {
                                    return checkIfFunctionUI(classVar: classInfo)
                                } else if let protocolInfo = protocols[varType] {
                                    // протокол
                                    if let allClassAndStruct = inheritanceAndImplementation[protocolInfo.name] {
                                        
                                    }
                                }
                            }
                        } else {
                            // скорее всего класс
                            let classNamePattern = #"\b\w+(?=\(\))"#
                            let string = file.lines[match]
                            if let range = regexChecker.checkStringRegexRange(pattern: classNamePattern, string: file.lines[match]) {
                                varType = (string as NSString).substring(with: range)
                                if let classInfo = classes[varType] {
                                    return checkIfFunctionUI(classVar: classInfo)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            // в этом классе
            let classes = projectFunctions[function.functionCall]
            if let functionClass = classes?.filter({ $0.file.path == function.path}).first {
                return checkIfFunctionUI(classVar: functionClass)
            }
        }
        return false
    }
    
    private func checkIfFunctionUI(classVar: ClassInfo) -> Bool {
        let classContent = classVar.file.lines[classVar.startLine - classVar.endLine]
        let syntaxTree = Parser.parse(source: classContent)
        let syntaxVisitor = ClassVariablesFinder(viewMode: .fixedUp)
        syntaxVisitor.walk(syntaxTree)
        let classVariables = syntaxVisitor.classVariables
        let functionBodyVisitor = FunctionBodyChecker(viewMode: .fixedUp)
        functionBodyVisitor.classVariables = classVariables
        functionBodyVisitor.uikitClasses = uikitClasses
        functionBodyVisitor.walk(syntaxTree)
        return functionBodyVisitor.isUIfunction
    }
}

class ClassVariablesFinder: SyntaxVisitor {
    var classVariables: Dictionary<String, String> = [:]
    
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if let varName = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
           let type =  node.bindings.first?.typeAnnotation?.type.as(IdentifierTypeSyntax.self) {
            classVariables[varName.description] = type.name.description
        }
        return .visitChildren
    }
    
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }
}

class FunctionBodyChecker: SyntaxVisitor {
    
    var classVariables: Dictionary<String, String> = [:]
    var uikitClasses: Set<String> = Set<String>()
    var isUIfunction: Bool = false
    
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if let varName = node.bindings.first?.pattern.as(IdentifierPatternSyntax.self),
           let type =  node.bindings.first?.typeAnnotation?.type.as(IdentifierTypeSyntax.self) {
            classVariables[varName.description] = type.name.description
        }
        return .visitChildren
    }
    
    override func visit(_ node: InfixOperatorExprSyntax) -> SyntaxVisitorContinueKind {
        if let varName = node.leftOperand.as(MemberAccessExprSyntax.self)?.base {
            if let type = classVariables[varName.description] {
                if uikitClasses.contains(type) {
                    isUIfunction = true
                }
            }
        }
        return .skipChildren
    }
}
