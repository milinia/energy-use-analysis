//
//  QoSDispatchQueueGlobalCheck.swift
//  diploma
//
//  Created by Evelina on 13.03.2024.
//

import Foundation
import SwiftSyntax

class QoSDispatchQueueGlobalCheck: MetricCheck {
    
    let dispatchQueueRegexPattern: String = "(DispatchQueue.global())"
    let qosRegexPattern: String = "(DispatchQueue.global(qos:).+"
    let regexChecker: RegexChecker
    
    init(regexChecker: RegexChecker) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        var errors:[MetricErrorData] = []
        let fileText = String(data: file.data, encoding: .utf8) ?? ""
        let dispatchQueueGlobalUsage = regexChecker.checkTextRegex(pattern: dispatchQueueRegexPattern, text: fileText)
        if (!dispatchQueueGlobalUsage.isEmpty) {
            let fileLines = file.lines
            for line in 0...fileLines.count - 1 {
                if regexChecker.checkStringRegex(pattern: qosRegexPattern, string: String(fileLines[line])) {
                    errors.append(MetricErrorData(type: QualityOfService.qosForTask, range: ErrorRange(start: line, end: line), 
                                                  file: file,
                                                  canFixError:  true))
                }
            }
        }
        return errors
    }
}
