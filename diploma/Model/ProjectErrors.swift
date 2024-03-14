//
//  ProjectErrors.swift
//  diploma
//
//  Created by Evelina on 19.02.2024.
//

import Foundation

//struct ProjectErrors: Codable, Hashable {
//    let errors: Dictionary<String, [MetricErrorData]>
//    let project: Project
//    
//    static func == (lhs: ProjectErrors, rhs: ProjectErrors) -> Bool {
//        return lhs.project == rhs.project
//    }
//    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(project)
//    }
    
//    enum CodingKeys: String, CodingKey {
//        case errors, project
//    }
//    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        errors = try values.decode([String: MetricError].self, forKey: .errors)
//        project = try values.decode(Project.self, forKey: .project)
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(errors, forKey: .errors)
//        try container.encode(project, forKey: .project)
//    }
//}
