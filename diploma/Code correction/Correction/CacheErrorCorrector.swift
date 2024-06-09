//
//  CacheErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class CacheErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int {
        let offset = fileOffset[error.file.path] ?? 0
        switch error.type {
        case let cacheError as CacheError:
            switch cacheError {
            case .cashingImages:
                correctCashingImagesError(error: error)
            case .cashingRequests:
                correctCacheRequestsError(error: error, offset: offset)
                return 1
            }
        default: break
        }
        return 0
    }
    
    private func correctCashingImagesError(error: MetricErrorData) {
        
    }
    
    private func correctCacheRequestsError(error: MetricErrorData, offset: Int) {
        let line = error.file.lines[error.range.start - 1 + offset]
        let pattern = #"(?:let|var)\s+(\w+)\s*=\s*URLRequest\([^)]*\)"#
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
        let newLine = String(repeating: " ", count: error.file.lines[error.range.start - 1 + offset].spaceFromLineStart) + "\(varName).cachePolicy = .reloadRevalidatingCacheData"
        error.file.lines.insert(newLine, at: error.range.start + offset)
    }
}
