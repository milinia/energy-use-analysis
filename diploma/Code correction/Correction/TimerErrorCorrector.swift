//
//  TimerErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class TimerErrorCorrector: Corrector {
    
    var varCountForFile: Dictionary<String, Int> = [:]
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let timerError as TimerError:
            switch timerError {
            case .timerTimeout:
                break
            case .timerTolerace:
                correctTimerToleraceError(error: error)
            }
        default: break
        }
        return error
    }
    
    private func correctTimerTimeoutError() {
        
    }
    
    private func correctTimerToleraceError(error: MetricErrorData) {
        let line = error.file.lines[error.range.start]
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
            var newLine = String(repeating: " ", count: error.file.lines[error.range.start].spaceFromLineStart)
            newLine += "\(varName).tolerance = 0.1"
            error.file.lines[error.range.end + 1].append(newLine)
        } else {
            let spaceFromLineStart = error.file.lines[error.range.start].spaceFromLineStart
            if let value = varCountForFile[error.file.path] {
                var newLine = error.file.lines[error.range.start]
                newLine.insert(contentsOf: "let timer\(value + 1) = ",
                                    at: newLine.index(newLine.startIndex, offsetBy: spaceFromLineStart))
                error.file.lines[error.range.start] = newLine
                varCountForFile[error.file.path] = value + 1
            } else {
                varCountForFile[error.file.path] = 1
            }
        }
    }
}
