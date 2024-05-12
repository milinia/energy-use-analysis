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
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
        }
    }
}

struct ContentRowFile_Previews: PreviewProvider {
    static var previews: some View {
        ContentRow(contentData: ContentRowData(content: DFile(path: "Downloads/Class.swift", type: .swift, data: Data()), isHasError: true))
    }
}

struct ContentRowFolder_Previews: PreviewProvider {
    static var previews: some View {
        ContentRow(contentData: ContentRowData(content: DFolder(path: "Downloads/Assets", content: []), isHasError: false))
    }
}
