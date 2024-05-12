//
//  TimerErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class TimerErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let timerError as TimerError:
            switch timerError {
            case .timerTimeout:
                break
            case .timerTolerace:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctTimerTimeoutError() {
        
    }
    
    private func correctTimerToleraceError(error: MetricErrorData) {
        let line = error.file.lines[error.range.start]
    }
}
