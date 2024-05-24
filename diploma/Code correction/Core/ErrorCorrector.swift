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
    
    var delegates: Dictionary<String, [String]> = [:]
    var classes: Dictionary<String, (DFile, ClassInfo)> = [:]
    
    init(delegates: Dictionary<String, [String]>, classes: Dictionary<String, (DFile, ClassInfo)>) {
        self.delegates = delegates
        self.classes = classes
    }
    
    func correctErrors(errors: [MetricErrorData], project: Project) {
        for error in errors {
            correctError(error: error)
        }
    }
    
    func correctError(error: MetricErrorData) {
        switch error.type {
        case is Location:
            if let delegates = delegates["Core Location"] {
                if let className = delegates.first {
                    if let info = classes[className] {
                        
                    }
                }
            }
        case is TimerError: break
        case is Bluetooth:
            if let delegates = delegates["Core Bluetooth"] {
                if let className = delegates.first {
                    if let info = classes[className] {
                        
                    }
                }
            }
        case is Motion:
            if let delegates = delegates["Core Motion"] {
                if let className = delegates.first {
                    if let info = classes[className] {
                        
                    }
                }
            }
        case is Brightness: break
        case is Reaction: break
        case is CacheError: break
        case is QualityOfService: break
        case is RetryDelay: break
        case is ComputeTask: break
        default: break
        }
    }
}
