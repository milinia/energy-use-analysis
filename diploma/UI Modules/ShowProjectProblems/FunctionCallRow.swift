//
//  FunctionCallRow.swift
//  diploma
//
//  Created by Evelina on 01.06.2024.
//

import SwiftUI

struct FunctionCallRow: View {
    
    let functionCallData: FunctionExecutionTime
    
    var body: some View {
        HStack {
            Text(functionCallData.functionCall)
                .font(.system(size: 14, weight: .bold))
            Spacer()
            Text("in " + (functionCallData.path.relativePath ?? ""))
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(.gray)
        }
    }
}
