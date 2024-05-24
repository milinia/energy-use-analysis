//
//  MotionErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class MotionErrorCorrector: Corrector {
    
    let file: DFile
    let classInfo: ClassInfo
    let regexChecker: RegexChecker
    
    init(file: DFile, classInfo: ClassInfo, regexChecker: RegexChecker) {
        self.file = file
        self.classInfo = classInfo
        self.regexChecker = regexChecker
    }
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let motionError as Motion:
            switch motionError {
            case .unstoppableWork:
                break
            case .unsetedInterval:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctUnsetedIntervalError() {
        let lines = Array(file.lines[classInfo.startLine...classInfo.endLine])
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
                        file.lines[classInfo.startLine + i].append(accelerometerUpdateInterval)
                        file.lines[classInfo.startLine + i].append(gyroUpdateInterval)
                        file.lines[classInfo.startLine + i].append(deviceMotionUpdateInterval)
                    }
                }
            }
        }
    }
    
    private func correctUnstoppableWorkError() {
        // нет исправления
    }
}
