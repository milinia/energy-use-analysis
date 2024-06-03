//
//  ComputeTasksCheck.swift
//  diploma
//
//  Created by Evelina on 24.05.2024.
//

import Foundation
import Files

class ComputeTasksCheck: MetricCheck {
    
    func getFunctionExectionTime(path: String) {
        var functionCall: [FunctionExecutionTime] = []
        do {
            let file = try File(path: path)
            let data = try file.read()
            if let text = String(data: data, encoding: .utf8) {
                let lines = text.split(separator: "\n")
                for line in lines {
                    let parts = line.split(separator: " ")
                    functionCall.append(FunctionExecutionTime(path: String(parts[0]),
                                                              line: Int(parts[1]) ?? 0,
                                                              functionCall: String(parts[2]),
                                                              isOnMainThread: Bool(String(parts[3])) ?? false,
                                                              executionTime: Double(String(parts[4])) ?? 0))
                }
            }
        } catch {
            
        }
        let sortedFunctionCalls = functionCall.sorted { $0.executionTime > $1.executionTime }
        let functionCallsMoreThan100 = functionCall.filter({ $0.executionTime > 0.1 })
    }
    
    func check(file: DFile) -> [MetricErrorData] {
        return []
    }
}
