//
//  ChooseProjectViewModel.swift
//  diploma
//
//  Created by Evelina on 19.01.2024.
//

import Foundation
import SwiftUI

final class ChooseProjectViewModel: ObservableObject {
    
    private let projectReader = ProjectReaderImpl(fileManager: FileManager())
    
    func readProject(path: URL, comletionHandler: @escaping ((Project) -> Void)) {
        do {
            let temp = try projectReader.readProject(projectPath: path)
            let project = temp.0
            let files = temp.1
            let projectTraverser = ProjectTraverserImpl()
            let errors = projectTraverser.traverse(files: files)
//            let projectErrors = ProjectErrors(errors: errors, project: project)
            comletionHandler(project)
        } catch {
            
        }
    }
    
}
