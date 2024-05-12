//
//  BluetoothErrorCorrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

class BluetoothErrorCorrector: Corrector {
    
    func correct(error: MetricErrorData) -> MetricErrorData {
        switch error.type {
        case let bluetoothError as Bluetooth:
            switch bluetoothError {
            case .unstoppableWork:
                break
            case .allowedDuplicatesOption:
                break
            }
        default: break
        }
        return error
    }
    
    private func correctUnstoppableWorkError() {
        
    }
    
    private func correctAllowedDuplicatesOptionError() {
        
    }
}
