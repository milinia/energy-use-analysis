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
    case highAccuracy = "High location accuracy is selected"
    case activityType = "Activity type"
    case allowBackgroundWork = "Getting a location works in the background"
    case pauseUpdatesAutomatically = "Prevents the system from updates if they are not needed"
    case unstoppableWork  = ""
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Timer: String, MetricError {
    case timerTimeout = ""
    case timerTolerace = "Not set tolelance for timer"
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Bluetooth: String, MetricError {
    case unstoppableWork = ""
    case allowedDuplicatesOption = "Central disabled filtering and generates a discovery event each time it receives an advertising packet from the peripheral"
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Motion: String, MetricError {
    case unstoppableWork = ""
    case unsetedInterval = "Setted interval hepls to increase battery life"
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Brightness: String, MetricError {
    case highBrightness = ""
    case unableDarkThemeInInfoPlist = "Turned off dark theme in Info.plist"
    case unableViewDarkTheme = "Dark theme let "
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Reaction: String, MetricError {
    case lowPowerModeEnable = "It good to react when system has not much energy"
    case deviceBatteryStateChanged = "It good to react when device charged"
    case applicationEntersBackground = ""
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum Cashing: String, MetricError {
    case cashingImages = "Images should be cashed"
    case cashingRequests = ""
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum QualityOfService: String, MetricError {
    case qosForTask = ""
    
    var errorMessage: String {
        return self.rawValue
    }
}
enum RetryDelay: String, MetricError {
    case retryDelayForRequest = ""
    
    var errorMessage: String {
        return self.rawValue
    }
}

struct MetricErrorData {
    let type: MetricError
    let range: ErrorRange
    let file: File
}

struct ErrorRange {
    let start: Int
    let end: Int
}
