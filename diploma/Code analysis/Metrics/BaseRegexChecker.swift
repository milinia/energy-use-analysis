//
//  BaseRegexChecker.swift
//  diploma
//
//  Created by Evelina on 15.05.2024.
//

import Foundation

protocol RegexCheck {
    func checkForPattern(file: DFile, regexPattern: String, error: MetricError) -> [MetricErrorData]
    func checkForPattern(file: DFile, regexPattern: String) -> Bool
}

class BaseRegexChecker: RegexCheck {
    
    let regexChecher: RegexChecker
    
    init(regexChecher: RegexChecker) {
        self.regexChecher = regexChecher
    }
    
    func checkForPattern(file: DFile, regexPattern: String, error: MetricError) -> [MetricErrorData] {
        if let text = String(data: file.data, encoding: .utf8) {
            let errorLines = regexChecher.checkTextRegex(pattern: regexPattern, text: text)
            var errors: [MetricErrorData]  = []
            for errorLine in errorLines {
                errors.append(MetricErrorData(type: error, range: ErrorRange(start: errorLine, end: errorLine), file: file, canFixError: true))
            }
            return errors
        } else {
            return []
        }
    }
    
    func checkForPattern(file: DFile, regexPattern: String) -> Bool {
        if let text = String(data: file.data, encoding: .utf8) {
            let errorLines = regexChecher.checkTextRegex(pattern: regexPattern, text: text)
            if !errorLines.isEmpty {
                return true
            }
        } else {
            return false
        }
        return false
    }
}
