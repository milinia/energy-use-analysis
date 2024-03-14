//
//  RegexChecker.swift
//  diploma
//
//  Created by Evelina on 05.03.2024.
//

import Foundation

protocol RegexChecker {
    func checkRegex(pattern: String, text: String) -> [Int]
}

final class RegexCheckerImpl: RegexChecker {
    
    func checkRegex(pattern: String, text: String) -> [Int] {
        var matches: [Int] = []
        let lines = text.split(separator: "\n")
        for index in 0...lines.count - 1 {
            let range = NSRange(location: 0, length: lines[index].utf8.count)
            do {
                let regex = try NSRegularExpression(pattern: pattern)
                if regex.firstMatch(in: String(lines[index]), range: range) != nil {
                    matches.append(index)
                }
            } catch {
                
            }
        }
        return matches
    }
}
