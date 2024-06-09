//
//  ErrorView.swift
//  diploma
//
//  Created by Evelina on 05.06.2024.
//

import SwiftUI

struct ErrorView: View {
    
    var errors: Dictionary<String, [MetricErrorData]>?
    @Binding var selectedFile: String
    @Binding var selectedErrorInFile: MetricErrorData?
    
    var body: some View {
        List {
            ForEach(errors?.keys.sorted() ?? [], id: \.self) { key in
                Section(header: Text(key.relativePath ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                ) {
                    ForEach(errors?[key] ?? []) { error in
                        Text("    " + error.type.errorMessage)
                            .onTapGesture {
                                selectedErrorInFile = error
                            }
                    }
                }
                .onTapGesture {
                    selectedFile = key
                }
            }
        }
    }
}
