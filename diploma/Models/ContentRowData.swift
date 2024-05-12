//
//  ContentRowData.swift
//  diploma
//
//  Created by Evelina on 20.12.2023.
//

import Foundation
import SwiftUI

struct ContentRowData {
    let content: Content
    
    var image: Image {
        switch content {
        case is DFile: return Image(systemName: "doc.fill")
        case is DFolder: return Image(systemName: "folder.fill")
        default: return Image(systemName: "questionmark.circle.fill")
        }
    }
    
    let isHasError: Bool
}
