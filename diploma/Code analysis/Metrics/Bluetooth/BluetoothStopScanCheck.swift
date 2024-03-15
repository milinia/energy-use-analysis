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
    
    func check(file: File) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Bluetooth.unstoppableWork)
    }
}
