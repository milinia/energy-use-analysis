//
//  BrightnessDarkModeAvaliableInfoPlistCheck.swift
//  diploma
//
//  Created by Evelina on 12.03.2024.
//

import Foundation

class BrightnessDarkModeAvaliableInfoPlistCheck: MetricCheck {
    
    let regexPattern: String = "(<key>UIUserInterfaceStyle</key>).+(<string>Light</string>)"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: File) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Brightness.unableDarkThemeInInfoPlist)
    }
}
