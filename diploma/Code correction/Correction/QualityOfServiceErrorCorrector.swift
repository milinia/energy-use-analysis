//
//  QualityOfServiceErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class QualityOfServiceErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int {
        let offset = fileOffset[error.file.path] ?? 0
        switch error.type {
        case let qosError as QualityOfService:
            switch qosError {
            case .qosForTask:
                correctQosForTaskError(error: error, offset: offset)
            }
        default: break
        }
        return 0
    }
    
    private func correctQosForTaskError(error: MetricErrorData, offset: Int) {
        var originalString = error.file.lines[error.range.start - 1 + offset]
        let spaceFromLineStart = originalString.spaceFromLineStart
        let newLine = originalString.replacingOccurrences(of: "global()", with: "global(qos: .userInitiated)")
        error.file.lines[error.range.start - 1 + offset] = newLine
    }
}
