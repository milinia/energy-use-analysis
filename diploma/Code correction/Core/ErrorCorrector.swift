//
//  ErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 02.04.2024.
//

import Foundation
import SwiftSyntax
import SwiftParser

class ErrorCorrector {
    
    var delegates: Dictionary<String, [String]>
    var classes: [ClassInfo]
    var projectInfo: ProjectInfo?
    
    private var regexChecker: RegexChecker
    private var locationErrorCorrector: LocationErrorCorrector
    private var bluetoothErrorCorrector: BluetoothErrorCorrector
    private var motionErrorCorrector: MotionErrorCorrector
    private var timerErrorCorrector: TimerErrorCorrector
    private var brightnessErrorCorrector: BrightnessErrorCorrector
    private var reactionErrorCorrector: ReactionErrorCorrector
    private var cacheErrorCorrector: CacheErrorCorrector
    private var qualityOfServiceErrorCorrector: QualityOfServiceErrorCorrector
    private var computeTaskErrorCorrector: ComputeTaskErrorCorrector
    
    init(delegates: Dictionary<String, [String]>, classes: [ClassInfo], projectInfo: ProjectInfo?) {
        self.delegates = delegates
        self.classes = classes
        self.regexChecker = RegexCheckerImpl()
        self.projectInfo = projectInfo
        let locationClass = classes.filter({$0.name == delegates["Core Location"]?.first}).first
        self.locationErrorCorrector = LocationErrorCorrector(classInfo: locationClass, regexChecker: regexChecker)
        let bluetoothClass = classes.filter({$0.name == delegates["Core Bluetooth"]?.first}).first
        self.bluetoothErrorCorrector = BluetoothErrorCorrector(classInfo: bluetoothClass, regexChecker: regexChecker)
        let motionClass = classes.filter({$0.name == delegates["Core Motion"]?.first}).first
        self.motionErrorCorrector = MotionErrorCorrector(classInfo: motionClass, regexChecker: regexChecker)
        self.timerErrorCorrector = TimerErrorCorrector()
        self.brightnessErrorCorrector = BrightnessErrorCorrector()
        self.reactionErrorCorrector = ReactionErrorCorrector()
        self.cacheErrorCorrector = CacheErrorCorrector()
        self.qualityOfServiceErrorCorrector = QualityOfServiceErrorCorrector()
        var classDict: Dictionary<String, ClassInfo> = [:]
        if let projectInfo = projectInfo {
            projectInfo.classNames.forEach { info in
                classDict[info.name] = info
            }
            var protocolsDict: Dictionary<String, ProtocolInfo> = [:]
            projectInfo.protocolNames.forEach { info in
                protocolsDict[info.name] = info
            }
            self.computeTaskErrorCorrector = ComputeTaskErrorCorrector(projectFunctions: projectInfo.projectFunctions,
                                                                       classes: classDict,
                                                                       protocols: protocolsDict,
                                                                       projectFiles: projectInfo.projectFiles)
        } else {
            self.computeTaskErrorCorrector = ComputeTaskErrorCorrector(projectFunctions: [:],
                                                                       classes: [:],
                                                                       protocols: [:],
                                                                       projectFiles: [])
        }
    }
    
    func correctFunctionCall(functionCall: FunctionExecutionTime, fileOffset: Dictionary<String, Int>) -> Int {
        return computeTaskErrorCorrector.correct(function: functionCall, fileOffset: fileOffset)
    }
    
    func correctError(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int {
        var offset = 0
        switch error.type {
        case is Location:
            if let delegates = delegates["Core Location"] {
                if let className = delegates.first {
                    if let classInfo = classes.filter({ info in
                        info.name == className
                    }).first {
                        offset = locationErrorCorrector.correct(error: error, fileOffset: fileOffset)
                    }
                }
            }
        case is TimerError: 
            offset = timerErrorCorrector.correct(error: error, fileOffset: fileOffset)
        case is Bluetooth:
            if let delegates = delegates["Core Bluetooth"] {
                if let className = delegates.first {
                    if let classInfo = classes.filter({ info in
                        info.name == className
                    }).first {
                        offset = bluetoothErrorCorrector.correct(error: error, fileOffset: fileOffset)
                    }
                }
            }
        case is Motion:
            if let delegates = delegates["Core Motion"] {
                if let className = delegates.first {
                    if let classInfo = classes.filter({ info in
                        info.name == className
                    }).first {
                        offset = motionErrorCorrector.correct(error: error, fileOffset: fileOffset)
                    }
                }
            }
        case is Brightness:
            offset = brightnessErrorCorrector.correct(error: error, fileOffset: fileOffset)
        case is Reaction:
            offset = reactionErrorCorrector.correct(error: error, fileOffset: fileOffset)
        case is CacheError:
            offset = cacheErrorCorrector.correct(error: error, fileOffset: fileOffset)
        case is QualityOfService:
            offset = qualityOfServiceErrorCorrector.correct(error: error, fileOffset: fileOffset)
        default: break
        }
        return offset
    }
}
