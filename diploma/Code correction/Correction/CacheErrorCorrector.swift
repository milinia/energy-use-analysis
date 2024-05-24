//
//  CacheErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class CacheErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let cacheError as CacheError:
            switch cacheError {
            case .cashingImages:
                break
            case .cashingRequests:
                correctCacheRequestsError(error: error)
            }
        default: break
        }
        return error
    }
    
    private func correctCashingImagesError() {
        
    }
    
    private func correctCacheRequestsError(error: MetricErrorData) {
        let line = error.file.lines[error.range.start]
        let pattern = "(?:let|var)?\\s*(\\w+)\\s*=\\s*URLRequest\\("
        var varName = ""
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            if let match = regex.firstMatch(in: line, options: [], range: NSRange(location: 0, length: line.utf16.count)) {
                if let range = Range(match.range(at: 1), in: line) {
                    varName =  String(line[range])
                }
            }
        } catch {
            
        }
        var newLine = String(repeating: " ", count: error.file.lines[error.range.start].spaceFromLineStart)
        newLine += "\(varName).cachePolicy = .reloadRevalidatingCacheData"
        error.file.lines[error.range.start + 1].append(newLine)
    }
}
