//
//  BluetoothErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class BluetoothErrorCorrector: Corrector {
    
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
        case let bluetoothError as Bluetooth:
            switch bluetoothError {
            case .unstoppableWork:
                break
            case .allowedDuplicatesOption:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctUnstoppableWorkError() {
        // нет исправления
    }
    
    private func correctAllowedDuplicatesOptionError() {
        let lines = Array(file.lines[classInfo.startLine...classInfo.endLine])
        for i in 0...lines.count - 1 {
            if let match = regexChecker.checkStringRegexRange(pattern: #"CBCentralManagerScanOptionAllowDuplicatesKey\s*:\s*true[,]*"#, string: lines[i]) {
                if let range = Range(match, in: lines[i]) {
                    file.lines[classInfo.startLine + i].removeSubrange(range)
                }
            }
        }
    }
}
