//
//  FileSaver.swift
//  diploma
//
//  Created by Evelina on 27.04.2024.
//

import Foundation
import Files

class FileSaver {
//    func saveFile(file: File) {
//        
//    }
//    func createFolder(name: String) {
//        
//    }
    
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
            let newFolder = try folder.createSubfolder(named: name)
        } catch {
            print("Error: \(error)")
        }
    }
}
