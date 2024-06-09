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
    
    private var project: Project?
    private var projectInfo: ProjectInfo?
    
    // проходит проект, генерирует все для отслеживания
    func readProject(path: URL, selectedProject: Binding<Project?>,
                     projectInfo: Binding<ProjectInfo?>,
                     completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                let temp = try self.projectReader.readProject(projectPath: path)
                let project = temp.0
                let info = temp.1
                let codeGeneration = CodeGeneration()
                codeGeneration.generate(project: project, projectInfo: info)
                DispatchQueue.main.async {
                    completion()
                }
                selectedProject.wrappedValue = project
                projectInfo.wrappedValue = info
                self.project = project
                self.projectInfo = info
            } catch {
                
            }
        }
    }
    
    // ищет ошибки, показывает их в проекте
    func findProjectErrors(errors: Binding<Dictionary<String, [MetricErrorData]>?>, 
                           projectInfo: Binding<ProjectInfo?>,
                           warnings: Binding<Dictionary<String, [Warning]>?>,
                           functionCalls: Binding<[FunctionExecutionTime]?>,
                           completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let project = self.project, let projectInfoFunc = self.projectInfo {
                let metricChecker = MetricChecker()
                let result = metricChecker.startChecking(project: project, projectInfo: projectInfoFunc)
                var resultErrors = result.0
                let computeTasksChecker = ComputeTasksCheck()
                let calls = computeTasksChecker.getFunctionExectionTime(path: project.path.path() + "Test/" + FileName.functionsTimeFile.rawValue)
                calls.forEach { call in
                    let file = projectInfoFunc.projectFiles.filter({$0.path == call.path}).first
                    if let file = file {
                        let metricError = MetricErrorData(type: ComputeTask.copmuteTaskInForeground,
                                                          range: ErrorRange(start: call.line, end: call.line),
                                                          file: file,
                                                          canFixError: true,
                                                          functionCall: call)
                        if (resultErrors[call.path] != nil) {
                            resultErrors[call.path]?.append(metricError)
                        } else {
                            resultErrors[call.path] = [metricError]
                        }
                    }
                }
                functionCalls.wrappedValue = calls
                errors.wrappedValue = resultErrors
                warnings.wrappedValue = result.1
                projectInfo.wrappedValue?.delegates = metricChecker.delegates
                
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
}
