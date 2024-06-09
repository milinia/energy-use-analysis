//
//  ContentRow.swift
//  diploma
//
//  Created by Evelina on 20.12.2023.
//

import SwiftUI

struct ContentRow: View {
    
    let contentData: ContentRowData
    
    var body: some View {
        HStack {
            contentData.image
                .resizable()
                .frame(width: 15, height: 15)
            Text(contentData.content.path.relativePath ?? "")
            Spacer()
            if contentData.isHasError {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
            }
        }
    }
}
