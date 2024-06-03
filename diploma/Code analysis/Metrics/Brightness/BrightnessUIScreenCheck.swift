//
//  BrightnessUIScreenCheck.swift
//  diploma
//
//  Created by Evelina on 28.05.2024.
//

import Foundation

class BrightnessUIScreenCheck: MetricCheck {
    
    let regexPattern: String = "(UIScreen).+(setBrightness:1.0)"
    let regexChecker: RegexCheck
    var count: Int = 0
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        let errors = regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Brightness.highBrightness)
        count += errors.count
        return errors
    }
}
