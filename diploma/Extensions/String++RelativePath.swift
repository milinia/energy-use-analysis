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
    var spaceFromLineStart: Int {
        var count = 0
        for char in self {
            if char == " " {
                count += 1
            } else {
                break
            }
        }
        return count
    }
}
