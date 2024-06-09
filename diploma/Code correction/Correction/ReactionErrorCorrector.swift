//
//  ReactionErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class ReactionErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int {
        switch error.type {
        case let reactionError as Reaction:
            switch reactionError {
            case .lowPowerModeEnable:
                correctLowPowerModeEnableError(error: error)
            case .deviceBatteryStateChanged:
                correctDeviceBatteryStateChangedError(error: error)
            case .applicationEntersBackground:
                correctApplicationEntersBackgroundError(error: error)
            }
        default: break
        }
        return 0
    }
    
    private func correctLowPowerModeEnableError(error: MetricErrorData) {
        
    }
    
    private func correctDeviceBatteryStateChangedError(error: MetricErrorData) {
        
    }
    
    private func correctApplicationEntersBackgroundError(error: MetricErrorData) {
        
    }
}
