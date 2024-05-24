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
                correctQosForTaskError(error: error)
            }
        default: break
        }
        return error
    }
    
    private func correctQosForTaskError(error: MetricErrorData) {
        let spaceFromLineStart = error.file.lines[error.range.start].spaceFromLineStart
        var originalString = error.file.lines[error.range.start]
        let newLine = originalString.replacingOccurrences(of: "global()", with: "global(qos: .userInitiated)")
        error.file.lines[error.range.start] = newLine
    }
}
