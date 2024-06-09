//
//  MetricCheck.swift
//  diploma
//
//  Created by Evelina on 13.12.2023.
//

import Foundation
import SwiftParser
import SwiftSyntax
import Files

protocol MetricCheck {
    func check(file: DFile) -> [MetricErrorData]
}

class MetricChecker {
    
    var errors: Dictionary<String, [MetricErrorData]>
    var delegates: Dictionary<String, [String]>
    let regexChecker: RegexChecker
    let baseChecker: RegexCheck
    let qoSDispatchQueueGlobalCheck: QoSDispatchQueueGlobalCheck
    let reactionLowPowerModeEnabledCheck: ReactionLowPowerModeEnabledCheck
    let reactionDeviceBatteryStateCheck: ReactionDeviceBatteryStateCheck
    let cacheURLRequestCachePolicyChecktVisitor: CacheURLRequestCachePolicyCheck
    let timerToleranceCheckVisitor: TimerToleranceCheck
    let brightnessDarkModeCheck: BrightnessDarkModeCheck
    let brightnessDarkModeAvaliableInfoPlistCheck: BrightnessDarkModeAvaliableInfoPlistCheck
    let brightnessUIScreenCheck: BrightnessUIScreenCheck
    let motionStopUpdatesCheck: MotionStopUpdatesCheck
    let motionUpdateIntervalCheck: MotionUpdateIntervalCheck
    let bluetoothOptionAllowDuplicatesCheck: BluetoothOptionAllowDuplicatesCheck
    let bluetoothStopScanCheck: BluetoothStopScanCheck
    let locationAccuracyCheck: LocationAccuracyCheck
    let locationAllowBackgroundUpdateCheck: LocationAllowBackgroundUpdateCheck
    let locationStopCheck: LocationStopCheck
    let locationPausesBackgroundUpdateAutomaticallyCheck: LocationPausesBackgroundUpdateAutomaticallyCheck
    let delegateCheck: DelegateCheck
    
    init() {
        self.errors = [:]
        self.delegates = [:]
        self.regexChecker = RegexCheckerImpl()
        self.baseChecker = BaseRegexChecker(regexChecher: regexChecker)
        self.qoSDispatchQueueGlobalCheck = QoSDispatchQueueGlobalCheck(regexChecker: regexChecker)
        self.reactionLowPowerModeEnabledCheck = ReactionLowPowerModeEnabledCheck(regexChecker: baseChecker)
        self.reactionDeviceBatteryStateCheck = ReactionDeviceBatteryStateCheck(regexChecker: baseChecker)
        self.cacheURLRequestCachePolicyChecktVisitor = CacheURLRequestCachePolicyCheck(viewMode: .fixedUp)
        self.timerToleranceCheckVisitor = TimerToleranceCheck(viewMode: .fixedUp)
        self.brightnessDarkModeCheck = BrightnessDarkModeCheck(regexChecker: baseChecker)
        self.brightnessDarkModeAvaliableInfoPlistCheck = BrightnessDarkModeAvaliableInfoPlistCheck(regexChecker: baseChecker)
        self.brightnessUIScreenCheck = BrightnessUIScreenCheck(regexChecker: baseChecker)
        self.motionStopUpdatesCheck = MotionStopUpdatesCheck(regexChecker: baseChecker)
        self.motionUpdateIntervalCheck = MotionUpdateIntervalCheck(regexChecker: baseChecker)
        self.bluetoothOptionAllowDuplicatesCheck = BluetoothOptionAllowDuplicatesCheck(regexChecker: baseChecker)
        self.bluetoothStopScanCheck = BluetoothStopScanCheck(regexChecker: baseChecker)
        self.locationAccuracyCheck = LocationAccuracyCheck(regexChecker: baseChecker)
        self.locationAllowBackgroundUpdateCheck = LocationAllowBackgroundUpdateCheck(regexChecker: baseChecker)
        self.locationStopCheck = LocationStopCheck(regexChecker: baseChecker)
        self.locationPausesBackgroundUpdateAutomaticallyCheck = LocationPausesBackgroundUpdateAutomaticallyCheck(regexChecker: baseChecker)
        self.delegateCheck = DelegateCheck(regexChecker: regexChecker)
    }
    
    
    func startChecking(project: Project, projectInfo: ProjectInfo) -> (Dictionary<String, [MetricErrorData]>, Dictionary<String, [Warning]>) {
        if let runtimeFile = getRuntimeFile(project: project) {
            let runtimeErrors = checkRuntimeFile(file: runtimeFile) //нет какого-то определенного файла, к которому можно прикрепить ошибки
//            print(runtimeErrors)
//            print(delegates)
        }
        let projectFiles = projectInfo.projectFiles
        projectFiles.forEach { file in
            let fileErrors = checkProjectFiles(file: file)
            if !fileErrors.isEmpty {
                errors[file.path] = fileErrors
            }
        }
        return (errors, [:])
    }
    
    func getRuntimeFile(project: Project) -> DFile? {
        do {
            let path = project.path.path() + "Test/" + FileName.calledFunctionFile.rawValue
            let file = try File(path: path)
            let runtimeFileData = try file.read()
            let runtimeFile = DFile(path: path, type: .other, data: runtimeFileData)
            return runtimeFile
        } catch {
            
        }
        return nil
    }
    
    func checkRuntimeFile(file: DFile) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        errors.append(contentsOf: checkReactionMetric(file: file))
        errors.append(contentsOf: checkBrightnessMetric(file: file))
        errors.append(contentsOf: checkMotionMetric(file: file))
        errors.append(contentsOf: checkBluetoothMetric(file: file))
        errors.append(contentsOf: checkLocatiohMetric(file: file))
        delegates = findDelegates(file: file)
        return errors
    }
    
    func checkProjectFiles(file: DFile) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        if let fileName = file.path.relativePath {
            if fileName.contains("Info.plist") {
                errors.append(contentsOf: brightnessDarkModeAvaliableInfoPlistCheck.check(file: file))
            } else if fileName.contains(".swift") {
                guard let fileContent = String(data: file.data, encoding: .utf8) else {return []}
                let syntaxTree = Parser.parse(source: fileContent)
                errors.append(contentsOf: checkCacheMetric(file: file, tree: syntaxTree))
                errors.append(contentsOf: checkTimerMetric(file: file, tree: syntaxTree))
                errors.append(contentsOf: checkQoSMetric(file: file, tree: syntaxTree))
            }
        }
        return errors
    }
    
    func checkTimerMetric(file: DFile, tree: SourceFileSyntax) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        timerToleranceCheckVisitor.file = file
        timerToleranceCheckVisitor.walk(tree)
        timerToleranceCheckVisitor.timerVariableNames.forEach { (key, value) in
            if value.0 == false {
                errors.append(MetricErrorData(type: TimerError.timerTolerace,
                                              range: ErrorRange(start: value.1.start, end: value.1.end),
                                              file: file, canFixError: true))
            }
        }
        timerToleranceCheckVisitor.timerVariableNames = [:]
        return errors
    }
    
    func checkCacheMetric(file: DFile, tree: SourceFileSyntax) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        cacheURLRequestCachePolicyChecktVisitor.file = file
        cacheURLRequestCachePolicyChecktVisitor.walk(tree)
        cacheURLRequestCachePolicyChecktVisitor.urlRequestVariableNames.forEach { (key, value) in
            if value.0 == false {
                errors.append(MetricErrorData(type: CacheError.cashingRequests,
                                              range: ErrorRange(start: value.1.start, end: value.1.end),
                                              file: file, canFixError: true))
            }
        }
        cacheURLRequestCachePolicyChecktVisitor.urlRequestVariableNames = [:]
        return errors
    }
    
    func checkQoSMetric(file: DFile, tree: SourceFileSyntax) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        qoSDispatchQueueGlobalCheck.check(file: file).forEach {
            errors.append($0)
        }
        return errors
    }
    
    func checkReactionMetric(file: DFile) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        reactionLowPowerModeEnabledCheck.check(file: file).forEach {
            errors.append($0)
        }
        reactionDeviceBatteryStateCheck.check(file: file).forEach {
            errors.append($0)
        }
        return errors
    }
    
    func checkBrightnessMetric(file: DFile) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        brightnessDarkModeCheck.check(file: file).forEach {
            errors.append($0)
        }
        brightnessUIScreenCheck.check(file: file).forEach {
            errors.append($0)
        }
        return errors
    }
    
    func checkMotionMetric(file: DFile) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        motionStopUpdatesCheck.check(file: file).forEach {
            errors.append($0)
        }
        motionUpdateIntervalCheck.check(file: file).forEach {
            errors.append($0)
        }
        return errors
    }
    
    func checkBluetoothMetric(file: DFile) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        bluetoothStopScanCheck.check(file: file).forEach {
            errors.append($0)
        }
        bluetoothOptionAllowDuplicatesCheck.check(file: file).forEach {
            errors.append($0)
        }
        return errors
    }
    
    func checkLocatiohMetric(file: DFile) -> [MetricErrorData] {
        var errors: [MetricErrorData] = []
        locationStopCheck.check(file: file).forEach {
            errors.append($0)
        }
        locationAccuracyCheck.check(file: file).forEach {
            errors.append($0)
        }
        locationAllowBackgroundUpdateCheck.check(file: file).forEach {
            errors.append($0)
        }
        locationPausesBackgroundUpdateAutomaticallyCheck.check(file: file).forEach {
            errors.append($0)
        }
        return errors
    }
    
    func findDelegates(file: DFile) -> Dictionary<String, [String]> {
        let delegateCheck = DelegateCheck(regexChecker: regexChecker)
        return delegateCheck.check(file: file)
    }
}

