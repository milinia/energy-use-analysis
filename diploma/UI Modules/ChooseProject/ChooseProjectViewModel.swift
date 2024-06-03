//
//  ChooseProjectViewModel.swift
//  diploma
//
//  Created by Evelina on 19.01.2024.
//

import Foundation
import SwiftUI

final class ChooseProjectViewModel: ObservableObject {
    
    private let projectReader = ProjectReaderImpl()
    @Published var progress = 0.0
    
    func readProject(path: URL, selectedProject: Binding<Project?>, errors: Binding<Dictionary<String, [MetricErrorData]>?>,  completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            do {
                let temp = try self.projectReader.readProject(projectPath: path)
                let project = temp.0
                let files = temp.1
                let projectTraverser = ProjectTraverserImpl()
                var projectErrors: Dictionary<String, [MetricErrorData]> = [:]
                //            let codeGeneration = CodeGeneration()
                //            codeGeneration.generate(project: project)
                DispatchQueue.main.async {
                    completion()
                }
                selectedProject.wrappedValue = project
                errors.wrappedValue = projectErrors
            } catch {
                // Handle error
            }
        }
    }
}
