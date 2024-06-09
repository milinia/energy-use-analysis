//
//  BluetoothErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class BluetoothErrorCorrector: Corrector {
    
    let classInfo: ClassInfo?
    let regexChecker: RegexChecker
    
    init(classInfo: ClassInfo?, regexChecker: RegexChecker) {
        self.classInfo = classInfo
        self.regexChecker = regexChecker
    }
    
    func correct(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int {
        let offset = fileOffset[error.file.path] ?? 0
        switch error.type {
        case let bluetoothError as Bluetooth:
            switch bluetoothError {
            case .unstoppableWork:
                correctUnstoppableWorkError(error: error)
            case .allowedDuplicatesOption:
                correctAllowedDuplicatesOptionError(error: error, offset: offset)
            }
        default: break
        }
        return 0
    }
    
    private func correctUnstoppableWorkError(error: MetricErrorData) {
        // нет исправления
    }
    
    private func correctAllowedDuplicatesOptionError(error: MetricErrorData, offset: Int) {
        if let classInfo = classInfo {
            let lines = Array(error.file.lines[classInfo.startLine - 1 + offset...classInfo.endLine - 1 + offset])
            for i in 0...lines.count - 1 {
                if let match = regexChecker.checkStringRegexRange(pattern: #"CBCentralManagerScanOptionAllowDuplicatesKey\s*:\s*true[,]*"#, string: lines[i]) {
                    if let range = Range(match, in: lines[i]) {
                        error.file.lines[classInfo.startLine + i - 1 + offset].removeSubrange(range)
                    }
                }
            }
        }
    }
}
