//
//  FileSaver.swift
//  diploma
//
//  Created by Evelina on 27.04.2024.
//

import Foundation
import Files

class FileSaver {
    
    static func createFile(content: [String], path: String, name: String) {
        do {
            let folder = try Folder(path: path)
            let newFile = try folder.createFile(named: name)
            try newFile.write(content.joined(separator: "\n"))
        } catch {
            print("Error: \(error)")
        }
    }
    
    static func createFolder(path: String, name: String) {
        do {
            let folder = try Folder(path: path)
            _ = try folder.createSubfolder(named: name)
        } catch {
            print("Error: \(error)")
        }
    }
    
    static func saveFile(file: DFile) {
        do {
            let fileStorage = try File(path: file.path)
            try fileStorage.write(file.lines.joined(separator: "\n"))
        } catch {
            print("Error: \(error)")
        }
    }
}
