//
//  LocationErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class LocationErrorCorrector: Corrector {
    
    let file: DFile
    let classInfo: ClassInfo
    let regexChecker: RegexChecker
    
    init(file: DFile, classInfo: ClassInfo, regexChecker: RegexChecker) {
        self.file = file
        self.classInfo = classInfo
        self.regexChecker = regexChecker
    }
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let locationError as Location:
            switch locationError {
            case .highAccuracy:
                correctHighAccuracyError(error: error)
            case .allowBackgroundWork:
                correctAllowBackgroundWorkError(error: error)
            case .pauseUpdatesAutomatically:
                correctPauseUpdatesAutomaticallyError(error: error)
            case .unstoppableWork:
                correctUnstoppableWorkError(error: error)
            }
        default: break
        }
        return error
    }
    
    private func correctHighAccuracyError(error: MetricErrorData) {
        let lines = Array(file.lines[classInfo.startLine...classInfo.endLine])
        for i in 0...lines.count - 1 {
            if regexChecker.checkStringRegex(pattern: ".desiredAccuracy = [kCLLocationAccuracyBestForNavigation|kCLLocationAccuracyBest]+", string: lines[i]) {
                file.lines[classInfo.startLine + i] = file.lines[classInfo.startLine + i]
                    .replacingOccurrences(of: "kCLLocationAccuracyBestForNavigation", with: "kCLLocationAccuracyNearestTenMeters")
                    .replacingOccurrences(of: "kCLLocationAccuracyBest", with: "kCLLocationAccuracyNearestTenMeters")
            }
        }
    }

    
    private func correctAllowBackgroundWorkError(error: MetricErrorData) {
        let lines = Array(file.lines[classInfo.startLine...classInfo.endLine])
        for i in 0...lines.count - 1 {
            if regexChecker.checkStringRegex(pattern: ".allowsBackgroundLocationUpdates = true", string: lines[i]) {
                file.lines[classInfo.startLine + i] = file.lines[classInfo.startLine + i].replacingOccurrences(of: "true", with: "false")
            }
        }
    }
    
    private func correctPauseUpdatesAutomaticallyError(error: MetricErrorData) {
        let lines = Array(file.lines[classInfo.startLine...classInfo.endLine])
        for i in 0...lines.count - 1 {
            if regexChecker.checkStringRegex(pattern: ".pausesLocationUpdatesAutomatically = false", string: lines[i]) {
                file.lines[classInfo.startLine + i] = file.lines[classInfo.startLine + i].replacingOccurrences(of: "false", with: "true")
            }
        }
    }
    
    private func correctUnstoppableWorkError(error: MetricErrorData) {
        // нет исправления
    }
}
