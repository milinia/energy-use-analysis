//
//  LocationPausesBackgroundUpdateAutomaticallyCheck.swift
//  diploma
//
//  Created by Evelina on 09.03.2024.
//

import Foundation

class LocationPausesBackgroundUpdateAutomaticallyCheck: MetricCheck {
    let regexPattern: String = "(CLLocationManager).+(setPausesLocationUpdatesAutomatically:false)"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Location.pauseUpdatesAutomatically)
    }
}
