//
//  RegexChecker.swift
//  diploma
//
//  Created by Evelina on 05.03.2024.
//

import Foundation

protocol RegexChecker {
    func checkTextRegex(pattern: String, text: String) -> [Int]
    func checkStringRegex(pattern: String, string: String) -> Bool
    func checkStringRegexRange(pattern: String, string: String) -> NSRange?
    func checkLinesRegex(pattern: String, lines: [String]) -> [Int]
}

final class RegexCheckerImpl: RegexChecker {
    
    func checkTextRegex(pattern: String, text: String) -> [Int] {
        var matches: [Int] = []
        let lines = text.split(separator: "\n")
        for index in 0...lines.count - 1 {
            if checkStringRegex(pattern: pattern, string: String(lines[index])) {
                matches.append(index)
            }
        }
        return matches
    }
    
    func checkLinesRegex(pattern: String, lines: [String]) -> [Int] {
        var matches: [Int] = []
        for index in 0...lines.count - 1 {
            if checkStringRegex(pattern: pattern, string: String(lines[index])) {
                matches.append(index)
            }
        }
        return matches
    }
    
    func checkStringRegex(pattern: String, string: String) -> Bool {
        do {
            let range = NSRange(location: 0, length: string.utf16.count)
            let regex = try NSRegularExpression(pattern: pattern)
            if range.location + range.length <= string.utf16.count {
                if regex.firstMatch(in: string, range: range) != nil {
                    return true
                } else {
                    return false
                }
            }
        } catch {
            
        }
        return false
    }
    
    func checkStringRegexRange(pattern: String, string: String) -> NSRange? {
        do {
            let range = NSRange(location: 0, length: string.utf16.count)
            let regex = try NSRegularExpression(pattern: pattern)
            if range.location + range.length <= string.utf16.count {
                if let match = regex.firstMatch(in: string, range: range) {
                    return match.range
                } else {
                    return nil
                }
            }
        } catch {
            
        }
        return nil
    }
}
