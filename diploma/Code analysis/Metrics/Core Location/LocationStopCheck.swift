//
//  LocationStopCheck.swift
//  diploma
//
//  Created by Evelina on 21.02.2024.
//

import Foundation

class LocationStopCheck: MetricCheck {
    let regexPattern: String = "(CLLocationManager).+(stopUpdatingLocation)"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Location.unstoppableWork)
    }
}
