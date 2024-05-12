//
//  ReactionDeviceBatteryStateCheck.swift
//  diploma
//
//  Created by Evelina on 13.03.2024.
//

import Foundation

class ReactionDeviceBatteryStateCheck: MetricCheck {
    
    let regexPattern: String = "(NSNotificationCenter).+(addObserver).+(name:@\"UIDeviceBatteryStateDidChangeNotification\")"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Reaction.deviceBatteryStateChanged)
    }
}
