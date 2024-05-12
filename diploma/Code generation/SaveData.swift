//
//  SaveData.swift
//  diploma
//
//  Created by Evelina on 03.05.2024.
//

import Foundation

//enum FileName: String {
//    case functionsTimeFile = "time.text"
//    case calledFunctionFile = "runtime.text"
//}

final class SaveData {
    
    static var projectPath: String = ""

    static func writeToFile(file: FileName, text: String) {
        let rootFolder = projectPath
        let path = rootFolder + file.rawValue
        do {
            try text.write(toFile: path, atomically: true, encoding: .utf8)
        } catch {
            
        }
    }
}
