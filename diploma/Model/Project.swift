//
//  Project.swift
//  diploma
//
//  Created by Evelina on 06.12.2023.
//

import Foundation


class Project: Codable, Hashable {
    let name: String
    let content: [Content]
    let path: URL
    
    init(name: String, content: [Content], path: URL) {
        self.name = name
        self.content = content
        self.path = path
    }
    
    static func == (lhs: Project, rhs: Project) -> Bool {
        return lhs.path == rhs.path
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
    }
}

class Content: Identifiable, Hashable, Codable {
    
    var id: UUID = UUID()
    let path: String
    let content: [Content]?
    
    init(path: String, content: [Content]? = nil) {
        self.path = path
        self.content = content
    }
    
    static func == (lhs: Content, rhs: Content) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class DFolder: Content {
    let сontent: [Content]
    
    init(path: String, content: [Content]) {
        self.сontent = content
        super.init(path: path, content: content)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class File: Content {
    let type: FileType
    let data: Data
    
    init(path: String, type: FileType, data: Data) {
        self.type = type
        self.data = data
        super.init(path: path)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

enum FileType: String {
    case json
    case properties
    case xcodeproj
    case xcworkspace
    case swift
    case storyboard
    case plist
    case bundle
    case yml
    case strings
    case ttf
    case pdf
    case jpg
    case jpeg
    case md
    case h
    case m
    case c
    case cpp
    case html
    case other
}
