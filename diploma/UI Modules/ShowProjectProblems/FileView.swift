//
//  FileView.swift
//  diploma
//
//  Created by Evelina on 15.02.2024.
//

import SwiftUI

struct FileView: View {
    let file: DFile?
    let errors: [MetricErrorData]?
    
    var body: some View {
        if let file = file {
            let text = String(data: file.data, encoding: .utf8) ?? ""
            let lines = text.components(separatedBy: "\n")
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(lines.indices, id: \.self) { index in
                        let line = lines[index]
                        Text(line)
                            .font(.title2)
                            .multilineTextAlignment(.center)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 16)
        }
    }
}
