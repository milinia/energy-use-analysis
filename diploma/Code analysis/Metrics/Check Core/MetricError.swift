//
//  MetricError.swift
//  diploma
//
//  Created by Evelina on 05.03.2024.
//

import Foundation

protocol MetricError {
    var errorMessage: String { get }
}

enum Location: String, MetricError {
    
    case highAccuracy = "High location accuracy is selected, which may lead to higher battery consumption."
    case allowBackgroundWork = "Getting a location works in the background, which could impact battery life."
    case pauseUpdatesAutomatically = "Prevents the system from updates if they are not needed, potentially reducing unnecessary battery drain."
    case unstoppableWork  = "Location services are continuously active, potentially causing significant battery drain."
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum TimerError: String, MetricError {
    case timerTimeout = "The timer has reached its timeout period without any further action."
    case timerTolerace = "No tolerance is set for the timer, which can lead to inefficient use of system resources."
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Bluetooth: String, MetricError {
    case unstoppableWork = "Bluetooth operations are running continuously, which may lead to excessive battery consumption."
    case allowedDuplicatesOption = "Central disabled filtering and generates a discovery event each time it receives an advertising packet from the peripheral, increasing processing load and power usage."
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Motion: String, MetricError {
    case unstoppableWork = "Motion sensors are active continuously, which can significantly impact battery life."
    case unsetedInterval = "Setting intervals for motion updates helps increase battery life by reducing the frequency of sensor activations."
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Brightness: String, MetricError {
    case highBrightness = "High screen brightness is set, which can lead to increased battery drain."
    case unableDarkThemeInInfoPlist = "Dark theme is disabled in Info.plist, potentially missing out on battery-saving benefits of dark mode."
    case unableViewDarkTheme = "Dark theme is not enabled for this view, potentially leading to higher power usage on OLED screens."
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Reaction: String, MetricError {
    case lowPowerModeEnable = "It is beneficial to adjust the app's behavior when the system is in low power mode to conserve battery."
    case deviceBatteryStateChanged = "Responding to changes in the device's battery state can help manage power usage effectively."
    case applicationEntersBackground = "Handling tasks appropriately when the application enters the background can optimize battery usage."
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum CacheError: String, MetricError {
    case cashingImages = "Images should be cached to improve performance and reduce network usage."
    case cashingRequests = "Requests should be cached to minimize redundant network calls and improve efficiency."
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum QualityOfService: String, MetricError {
    case qosForTask = "The quality of service (QoS) for this task is not set, which could lead to inefficient resource utilization."
    
    var errorMessage: String {
        return self.rawValue
    }
}

enum ComputeTask: String, MetricError {
    case copmuteTaskInForeground = "Compute-intensive tasks should be minimized in the foreground to ensure a smooth user experience and reduce battery drain."
    
    var errorMessage: String {
        return self.rawValue
    }
}

struct MetricErrorData: Identifiable, Equatable {
    let id: UUID = UUID()
    let type: MetricError
    let range: ErrorRange
    let file: DFile
    let canFixError: Bool
    let functionCall: FunctionExecutionTime?
    
    init(type: MetricError, range: ErrorRange, file: DFile, canFixError: Bool, functionCall: FunctionExecutionTime) {
        self.type = type
        self.range = range
        self.file = file
        self.canFixError = canFixError
        self.functionCall = functionCall
    }
    
    init(type: MetricError, range: ErrorRange, file: DFile, canFixError: Bool) {
        self.type = type
        self.range = range
        self.file = file
        self.canFixError = canFixError
        self.functionCall = nil
    }
    
    static func == (lhs: MetricErrorData, rhs: MetricErrorData) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct ErrorRange {
    let start: Int
    let end: Int
}
