//
//  MotionErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class MotionErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let motionError as Motion:
            switch motionError {
            case .unstoppableWork:
                break
            case .unsetedInterval:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctUnsetedIntervalError() {
        
    }
    
    private func correctUnstoppableWorkError() {
        
    }
}
