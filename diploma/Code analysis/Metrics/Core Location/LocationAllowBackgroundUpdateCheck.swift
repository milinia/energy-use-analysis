//
//  LocationAllowBackgroundUpdateCheck.swift
//  diploma
//
//  Created by Evelina on 21.02.2024.
//

import Foundation

class LocationAllowBackgroundUpdateCheck: MetricCheck {
    let regexPattern: String = "(CLLocationManager).+(setAllowsBackgroundLocationUpdates:true)"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Location.allowBackgroundWork)
    }
}

