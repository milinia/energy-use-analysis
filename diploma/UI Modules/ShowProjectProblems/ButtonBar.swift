//
//  ButtonBar.swift
//  diploma
//
//  Created by Evelina on 05.06.2024.
//

import SwiftUI

struct ButtonBar: View {
    
    @Binding var state: ProjectViewState
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                state = .project
            }) {
                Image(systemName: "folder.fill")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
            Button(action: {
                state = .errors
            }) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
        .padding(.vertical, 1)
    }
}
