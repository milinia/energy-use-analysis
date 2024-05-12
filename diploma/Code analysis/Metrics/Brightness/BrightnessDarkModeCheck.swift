//
//  BrightnessDarkModeCheck.swift
//  diploma
//
//  Created by Evelina on 12.03.2024.
//

import Foundation

class BrightnessDarkModeCheck: MetricCheck {
    
    let regexPattern: String = "(UIViewController).+(setOverrideUserInterfaceStyle:1)"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Brightness.unableViewDarkTheme)
    }
}
