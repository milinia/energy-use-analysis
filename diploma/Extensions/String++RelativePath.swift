//
//  String++RelativePath.swift
//  diploma
//
//  Created by Evelina on 16.02.2024.
//

import Foundation

extension String {
    var relativePath: String? {
        let components = self.components(separatedBy: "/")
        if components.last == "" {
            return components[components.count - 2]
        }
        return components.last
    }
}
