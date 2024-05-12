//
//  QualityOfServiceErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class QualityOfServiceErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let qosError as QualityOfService:
            switch qosError {
            case .qosForTask:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctQosForTasklError() {
        
    }
}
