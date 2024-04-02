//
//  MotionUpdateIntervalCheck.swift
//  diploma
//
//  Created by Evelina on 10.03.2024.
//

import Foundation

class MotionUpdateIntervalCheck: MetricCheck {
    
    let regexPattern: String = "(CMMotionManager).+([setGyroUpdateInterval|magnetometerUpdateInterval|accelerometerUpdateInterval|deviceMotionUpdateInterval])"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: File) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Motion.unsetedInterval)
    }
}
