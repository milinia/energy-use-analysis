//
//  BluetoothStopScanCheck.swift
//  diploma
//
//  Created by Evelina on 10.03.2024.
//

import Foundation

class BluetoothStopScanCheck: MetricCheck {
    
    let regexPattern: String = "(CBCentralManager).+(stopScan)"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        if !regexChecker.checkForPattern(file: file, regexPattern: regexPattern) {
            return [MetricErrorData(type: Bluetooth.unstoppableWork, range: ErrorRange(start: 0, end: 0), file: file, canFixError: false)]
        }
        return []
    }
}
