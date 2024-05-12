//
//  LocationErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class LocationErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let locationError as Location:
            switch locationError {
            case .highAccuracy:
                break
            case .activityType:
                break
            case .allowBackgroundWork:
                break
            case .pauseUpdatesAutomatically:
                break
            case .unstoppableWork:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctHighAccuracyError(error: MetricErrorData) {
        let line = error.file.lines[error.range.start]
        
    }
    
    private func correctActivityTypeError(error: MetricErrorData) {
        let line = error.file.lines[error.range.start]
    }
    
    private func correctAllowBackgroundWorkError(error: MetricErrorData) {
        let line = error.file.lines[error.range.start]
    }
    
    private func correctPauseUpdatesAutomaticallyError(error: MetricErrorData) {
        let line = error.file.lines[error.range.start]
    }
    
    private func correctUnstoppableWorkError(error: MetricErrorData) {
        let line = error.file.lines[error.range.start]
    }
}
