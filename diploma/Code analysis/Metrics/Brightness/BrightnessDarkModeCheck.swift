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
    var count: Int = 0
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        let errors = regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Brightness.unableViewDarkTheme)
        count += errors.count
        return errors
    }
}
