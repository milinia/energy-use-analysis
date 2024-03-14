//
//  MetricCheck.swift
//  diploma
//
//  Created by Evelina on 13.12.2023.
//

import Foundation

protocol RegexCheck {
    func checkForPattern(file: File, regexPattern: String, error: MetricError) -> [MetricErrorData]
}

protocol MetricCheck {
    func check(file: File) -> [MetricErrorData]
}

class BaseRegexChecker: RegexCheck {
    
    let regexChecher: RegexChecker
    
    init(regexChecher: RegexChecker) {
        self.regexChecher = regexChecher
    }
    
    func checkForPattern(file: File, regexPattern: String, error: MetricError) -> [MetricErrorData] {
        if let text = String(data: file.data, encoding: .utf8) {
            let errorLines = regexChecher.checkRegex(pattern: regexPattern, text: text)
            var errors: [MetricErrorData]  = []
            for errorLine in errorLines {
                errors.append(MetricErrorData(type: error, range: ErrorRange(start: errorLine, end: errorLine), file: file))
            }
            return errors
        } else {
            return []
        }
    }
}
