//
//  MotionErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class MotionErrorCorrector: Corrector {
    
    let classInfo: ClassInfo?
    let regexChecker: RegexChecker
    
    init(classInfo: ClassInfo?, regexChecker: RegexChecker) {
        self.classInfo = classInfo
        self.regexChecker = regexChecker
    }
    
    func correct(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int {
        let offset = fileOffset[error.file.path] ?? 0
        switch error.type {
        case let motionError as Motion:
            switch motionError {
            case .unstoppableWork:
                correctUnstoppableWorkError(error: error)
                return 0
            case .unsetedInterval:
                correctUnsetedIntervalError(error: error, offset: offset)
                return 3
            }
        default: break
        }
        return 0
    }
    
    private func correctUnsetedIntervalError(error: MetricErrorData, offset: Int) {
        if let classInfo = classInfo {
            let lines = Array(error.file.lines[classInfo.startLine - 1 + offset...classInfo.endLine - 1 + offset])
            for i in 0...lines.count - 1 {
                if regexChecker.checkStringRegex(pattern: #"\bCMMotionManager\s*\(.*?\)"#, string: lines[i]) {
                    let pattern = #"\b([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*CMMotionManager\s*\(.*?\)"#
                    let regex = try! NSRegularExpression(pattern: pattern, options: [])
                    if let match = regex.matches(in: lines[i], options: [], range: NSRange(location: 0, length: lines[i].utf16.count)).first {
                        if let range = Range( match.range(at: 1), in: lines[i]) {
                            let name = String(lines[i][range])
                            let spaceCount = lines[i].spaceFromLineStart
                            var accelerometerUpdateInterval = String(repeating: " ", count: spaceCount)
                            var gyroUpdateInterval = String(repeating: " ", count: spaceCount)
                            var deviceMotionUpdateInterval = String(repeating: " ", count: spaceCount)
                            accelerometerUpdateInterval += "\(name).accelerometerUpdateInterval = 0.2"
                            gyroUpdateInterval += "\(name).gyroUpdateInterval = 0.2"
                            deviceMotionUpdateInterval += "\(name).deviceMotionUpdateInterval = 0.2"
                            error.file.lines[classInfo.startLine - 1 + i + offset].append(accelerometerUpdateInterval)
                            error.file.lines[classInfo.startLine - 1 + i + offset].append(gyroUpdateInterval)
                            error.file.lines[classInfo.startLine - 1 + i + offset].append(deviceMotionUpdateInterval)
                        }
                    }
                }
            }
        }
    }
    
    private func correctUnstoppableWorkError(error: MetricErrorData) {
        // нет исправления
    }
}
