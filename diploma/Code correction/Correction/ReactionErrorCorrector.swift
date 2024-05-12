//
//  ReactionErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class ReactionErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let reactionError as Reaction:
            switch reactionError {
            case .lowPowerModeEnable:
                break
            case .deviceBatteryStateChanged:
                break
            case .applicationEntersBackground:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctLowPowerModeEnableError() {
        
    }
    
    private func correctDeviceBatteryStateChangedError() {
        
    }
    
    private func correctApplicationEntersBackgroundError() {
        
    }
}
