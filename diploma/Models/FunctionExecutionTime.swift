//
//  FunctionExecutionTime.swift
//  diploma
//
//  Created by Evelina on 24.05.2024.
//

import Foundation

struct FunctionExecutionTime: Identifiable {
    var id: UUID = UUID()
    let path: String
    let line: Int
    let functionCall: String
    let isOnMainThread: Bool
    let executionTime: Double
}
