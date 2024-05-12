//
//  BrightnessErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class BrightnessErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let brightnessError as Brightness:
            switch brightnessError {
            case .highBrightness:
                break
            case .unableDarkThemeInInfoPlist:
                break
            case .unableViewDarkTheme:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctHighBrightnessError() {
        
    }
    
    private func correctUnableDarkThemeInInfoPlistError() {
        
    }
    
    private func correctUnableViewDarkThemeError() {
        
    }
}
