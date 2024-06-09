//
//  LocationErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class LocationErrorCorrector: Corrector {
    
    let classInfo: ClassInfo?
    let regexChecker: RegexChecker
    
    init(classInfo: ClassInfo?, regexChecker: RegexChecker) {
        self.classInfo = classInfo
        self.regexChecker = regexChecker
    }
    
    func correct(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int {
        let offset = fileOffset[error.file.path] ?? 0
        switch error.type {
        case let locationError as Location:
            switch locationError {
            case .highAccuracy:
                correctHighAccuracyError(error: error, offset: offset)
            case .allowBackgroundWork:
                correctAllowBackgroundWorkError(error: error, offset: offset)
            case .pauseUpdatesAutomatically:
                correctPauseUpdatesAutomaticallyError(error: error, offset: offset)
            case .unstoppableWork:
                correctUnstoppableWorkError(error: error)
            }
        default: break
        }
        return 0
    }
    
    private func correctHighAccuracyError(error: MetricErrorData, offset: Int) {
        if let classInfo = classInfo {
            let lines = Array(error.file.lines[classInfo.startLine - 1 + offset...classInfo.endLine - 1 + offset])
            for i in 0...lines.count - 1 {
                if regexChecker.checkStringRegex(pattern: ".desiredAccuracy = [kCLLocationAccuracyBestForNavigation|kCLLocationAccuracyBest]+", string: lines[i]) {
                    error.file.lines[classInfo.startLine - 1 + i + offset] = error.file.lines[classInfo.startLine - 1 + i + offset]
                        .replacingOccurrences(of: "kCLLocationAccuracyBestForNavigation", with: "kCLLocationAccuracyNearestTenMeters")
                        .replacingOccurrences(of: "kCLLocationAccuracyBest", with: "kCLLocationAccuracyNearestTenMeters")
                }
            }
        }
    }

    
    private func correctAllowBackgroundWorkError(error: MetricErrorData, offset: Int) {
        if let classInfo = classInfo {
            let lines = Array(error.file.lines[classInfo.startLine - 1 + offset...classInfo.endLine - 1 + offset])
            for i in 0...lines.count - 1 {
                if regexChecker.checkStringRegex(pattern: ".allowsBackgroundLocationUpdates = true", string: lines[i]) {
                    error.file.lines[classInfo.startLine - 1 + i + offset] = error.file.lines[classInfo.startLine - 1 + i + offset].replacingOccurrences(of: "true", with: "false")
                }
            }
        }
    }
    
    private func correctPauseUpdatesAutomaticallyError(error: MetricErrorData, offset: Int) {
        if let classInfo = classInfo {
            let lines = Array(error.file.lines[classInfo.startLine - 1 + offset...classInfo.endLine - 1 + offset])
            for i in 0...lines.count - 1 {
                if regexChecker.checkStringRegex(pattern: ".pausesLocationUpdatesAutomatically = false", string: lines[i]) {
                    error.file.lines[classInfo.startLine - 1 + i + offset] = error.file.lines[classInfo.startLine - 1 + i + offset].replacingOccurrences(of: "false", with: "true")
                }
            }
        }
    }
    
    private func correctUnstoppableWorkError(error: MetricErrorData) {
        // нет исправления
    }
}
