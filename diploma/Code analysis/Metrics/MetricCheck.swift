//
//  MetricCheck.swift
//  diploma
//
//  Created by Evelina on 13.12.2023.
//

import Foundation
import SwiftParser
import SwiftSyntax

protocol MetricCheck {
    func check(file: DFile) -> [MetricErrorData]
}

class MetricChecker {
    
    var errors: [MetricErrorData] = []
    var delegates: Dictionary<String, [String]> = [:]
    var classes: Dictionary<String, ClassInfo> = [:]
    var protocols: Dictionary<String, ProtocolInfo> = [:]
    let regexChecker: RegexChecker = RegexCheckerImpl()
    
    func checkFile(file: DFile) -> [MetricErrorData] {
        guard let fileContent = String(data: file.data, encoding: .utf8) else {return []}
        let syntaxTree = Parser.parse(source: fileContent)
        checkCacheMetric(file: file, tree: syntaxTree)
        checkTimerMetric(file: file, tree: syntaxTree)
        checkQoSMetric(file: file, tree: syntaxTree)
        findDelegates(file: file)
        return errors
    }
    
    func checkTimerMetric(file: DFile, tree: SourceFileSyntax) {
        let syntaxVisitor = TimerToleranceCheck(viewMode: .fixedUp)
        syntaxVisitor.file = file
        syntaxVisitor.walk(tree)
        syntaxVisitor.timerVariableNames.forEach { (key, value) in
            if value.0 == false {
                errors.append(MetricErrorData(type: TimerError.timerTolerace,
                                              range: ErrorRange(start: value.1.start, end: value.1.end),
                                              file: file, canFixError: true))
            }
        }
    }
    
    func checkCacheMetric(file: DFile, tree: SourceFileSyntax) {
        let syntaxVisitor = CacheURLRequestCachePolicyCheck(viewMode: .fixedUp)
        syntaxVisitor.file = file
        syntaxVisitor.walk(tree)
        syntaxVisitor.urlRequestVariableNames.forEach { (key, value) in
            if value.0 == false {
                errors.append(MetricErrorData(type: CacheError.cashingRequests,
                                              range: ErrorRange(start: value.1.start, end: value.1.end),
                                              file: file, canFixError: true))
            }
        }
    }
    
    func checkQoSMetric(file: DFile, tree: SourceFileSyntax) {
        let check = QoSDispatchQueueGlobalCheck(regexChecker: regexChecker)
        check.check(file: file).map({errors.append($0)})
    }
    
    func walkAllProjectClassesAndProtocols(file: DFile, tree: SourceFileSyntax) {
        let syntaxVisitor = ClassWalker(viewMode: .fixedUp)
        syntaxVisitor.file = file
        syntaxVisitor.walk(tree)
        syntaxVisitor.classNames.forEach { classInfo in
            classes[classInfo.name] = classInfo
        }
        syntaxVisitor.protocolNames.forEach { protocolInfo in
            protocols[protocolInfo.name] = protocolInfo
        }
    }
    
    func findDelegates(file: DFile) {
        let delegateCheck = DelegateCheck(regexChecker: regexChecker)
        delegateCheck.check(file: file, dict: &delegates)
    }
}

