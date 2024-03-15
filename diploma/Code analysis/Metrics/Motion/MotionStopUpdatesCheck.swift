//
//  MotionStopUpdatesCheck.swift
//  diploma
//
//  Created by Evelina on 10.03.2024.
//

import Foundation

class MotionStopUpdatesCheck: MetricCheck {
    
    let regexPattern: String = "(CMMotionManager).+([stopGyroUpdates | stopMagnetometerUpdates | stopAccelerometerUpdates | stopDeviceMotionUpdates])"
    let regexChecker: RegexCheck
    
    init(regexChecker: RegexCheck) {
        self.regexChecker = regexChecker
    }
    
    func check(file: File) -> [MetricErrorData] {
        return regexChecker.checkForPattern(file: file, regexPattern: regexPattern, error: Motion.unstoppableWork)
    }
}