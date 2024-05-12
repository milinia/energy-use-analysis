//
//  ReactionLowPowerModeEnabledCheck.swift
//  diploma
//
//  Created by Evelina on 11.03.2024.
//

import Foundation

class ReactionLowPowerModeEnabledCheck: MetricCheck {
    
    let regexPattern: String = "(NSNotificationCenter).+(addObserver).+(name:@\"NSProcessInfoPowerStateDidChangeNotification\")"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Reaction.lowPowerModeEnable)
    }
}
