//
//  CashingErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class CashingErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let cacheError as Cashing:
            switch cacheError {
            case .cashingImages:
                break
            case .cashingRequests:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctCashingImagesError() {
        
    }
    
    private func correctCashingRequestsError() {
        
    }
}
