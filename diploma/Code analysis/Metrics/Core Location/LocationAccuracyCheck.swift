//
//  LocationAccuracyCheck.swift
//  diploma
//
//  Created by Evelina on 21.02.2024.
//

import Foundation

class LocationAccuracyCheck: MetricCheck {
    
    let regexPattern: String = "(CLLocationManagerStateTracker).+(setDesiredAccuracy:[-1.0 | -2.0])"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: File) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Location.highAccuracy)
    }
}