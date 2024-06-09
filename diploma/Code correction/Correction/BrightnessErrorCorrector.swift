//
//  BrightnessErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class BrightnessErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int {
        switch error.type {
        case let brightnessError as Brightness:
            switch brightnessError {
            case .highBrightness:
                correctHighBrightnessError(error: error)
            case .unableDarkThemeInInfoPlist:
                correctUnableDarkThemeInInfoPlistError(error: error)
            case .unableViewDarkTheme:
                correctUnableViewDarkThemeError(error: error)
            }
        default: break
        }
        return 0
    }
    
    private func correctHighBrightnessError(error: MetricErrorData) {
        
    }
    
    private func correctUnableDarkThemeInInfoPlistError(error: MetricErrorData) {
        
    }
    
    private func correctUnableViewDarkThemeError(error: MetricErrorData) {
        
    }
}
