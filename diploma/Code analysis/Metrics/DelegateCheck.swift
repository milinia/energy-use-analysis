//
//  DelegateCheck.swift
//  diploma
//
//  Created by Evelina on 17.05.2024.
//

import Foundation

final class DelegateCheck {
    let coreLocationDelegateRegexPattern: String = "(CLLocationManager).+(setDelegate:<).+(>)"
    let coreBluetoothDelegateRegexPattern: String = "(CBCentralManager).+(setDelegate:<).+(>)"
    let coreMotionhDelegateRegexPattern: String = "(CMMotionManager).+(setDelegate:<).+(>)"
    let delegateClassNameRegexPattern: String = "setDelegate:<([^>]+):"
    let regexChecker: RegexChecker
    
    init(regexChecker: RegexChecker) {
        self.regexChecker = regexChecker
    }
    
    func check(file: DFile, dict: inout Dictionary<String, [String]>) {
        let locationManagerDelegates = findDelegates(file: file, pattern: coreLocationDelegateRegexPattern)
        let centralManagerDelegates = findDelegates(file: file, pattern: coreBluetoothDelegateRegexPattern)
        let motionManagerDelegates = findDelegates(file: file, pattern: coreMotionhDelegateRegexPattern)
        dict["Core Location"] = locationManagerDelegates
        dict["Core Motion"] = motionManagerDelegates
        dict["Core Bluetooth"] = centralManagerDelegates
    }
    
    private func findDelegates(file: DFile, pattern: String) -> [String] {
        let text = String(data: file.data, encoding: .utf8) ?? ""
        let finded = regexChecker.checkTextRegex(pattern: pattern, text: text)
        for find in finded {
            let line = file.lines[find]
            let regex = try! NSRegularExpression(pattern: delegateClassNameRegexPattern, options: [])
            let matches = regex.matches(in: line, options: [], range: NSRange(location: 0, length: line.utf8.count))
            let className = matches.map { match in
                (line as NSString).substring(with: match.range(at: 1))
            }
            return className
        }
        return []
    }
}
