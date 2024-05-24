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
        if !regexChecker.checkForPattern(file: file, regexPattern: regexPattern) {
            return [MetricErrorData(type: Location.unstoppableWork, range: ErrorRange(start: 0, end: 0), file: file, canFixError: false)]
        }
        return []
    }
}
