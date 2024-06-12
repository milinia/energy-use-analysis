//
//  Project.swift
//  diploma
//
//  Created by Evelina on 06.12.2023.
//

import Foundation


class Project: Codable, Hashable, NSCopying {
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
    
    func copy(with zone: NSZone? = nil) -> Any {
        var contentCopies: [Content] = []
        content.forEach { content in
            if let content = content.copy() as? Content {
                contentCopies.append(content)
            }
        }
        let copy = Project(name: name, content: contentCopies, path: path)
        return copy
    }
    
}

class Content: Identifiable, Hashable, Codable, NSCopying {
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
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Content(path: path, content: content)
        return copy
    }
}

class DFolder: Content {
    let сontent: [Content]
    
    init(path: String, content: [Content]) {
        self.сontent = content
        super.init(path: path, content: content)
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        var contentCopies: [Content] = []
        content?.forEach { content in
            if let content = content.copy() as? Content {
                contentCopies.append(content)
            }
        }
        let copy = DFolder(path: path, content: contentCopies)
        return copy
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}

class DFile: Content {
    let type: FileType
    let data: Data
    var lines: [String]
    
    init(path: String, type: FileType, data: Data) {
        self.type = type
        self.data = data
        self.lines = String(data: data, encoding: .utf8)?.components(separatedBy: .newlines) ?? []
        super.init(path: path)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = DFile(path: path, type: type, data: data)
        return copy
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
