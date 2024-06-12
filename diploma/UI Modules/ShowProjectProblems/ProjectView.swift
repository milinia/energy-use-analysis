//
//  ProjectView.swift
//  diploma
//
//  Created by Evelina on 13.12.2023.
//

import SwiftUI

enum ProjectViewState {
    case project
    case errors
}

struct ProjectView: View {
    
    @Binding var errors: Dictionary<String, [MetricErrorData]>?
    @Binding var selectedProject: Project?
    @Binding var projectInfo: ProjectInfo?
    @Binding var warnings: Dictionary<String, [Warning]>?
    @Binding var functionCalls: [FunctionExecutionTime]?
    
    @State private var selectedContent: Content.ID?
    @State private var selectedError: Content.ID?
    @StateObject var viewModel = ProjectViewModel()
    @State private var state: ProjectViewState = .project
    @State private var selectedErrorInFile: MetricErrorData? = nil
    @State private var selectedFile: String = ""
    @State private var selectedFunctionCall: FunctionExecutionTime? = nil
    @State private var fileToShow: DFile?
    
    var body: some View {
        if let project = selectedProject {
            NavigationSplitView {
                Divider()
                ButtonBar(state: $state)
                Divider()
                switch state {
                case .project:
                    List(project.content, children: \.content, selection: $selectedContent) { item in
                        ContentRow(contentData: ContentRowData(content: item, isHasError: ((errors?[item.path] != nil) ? true : false)))
                            .onAppear {
                                saveContent(content: item)
                            }
                    }
                case .errors:
                    ErrorView(errors: errors, selectedFile: $selectedFile, selectedErrorInFile: $selectedErrorInFile)
                }
            } detail: {
                getView()
            }
        } else {
            Text("This project unavailable")
        }
    }
    
    func getView() -> some View {
            switch state {
            case .project:
                return getProjectView()
            case .errors:
                return getErrorView()
            }
        }
        
        func getProjectView() -> AnyView {
            let element = viewModel.contentDictionary[selectedContent ?? UUID()]
            if let file = element as? DFile {
                updateFileToShow(file)
                return AnyView(FileView(viewFile: $fileToShow,
                                        errors: errors?[file.path], projectErrors: $errors,
                                        selectedProject: $selectedProject,
                                        projectInfo: $projectInfo, viewModel: FileViewModel(project: $selectedProject,
                                                                                            projectInfo: $projectInfo)))
            } else {
                return AnyView(Image(systemName: ""))
            }
        }
        
        func getErrorView() -> AnyView {
            if let file = projectInfo?.projectFiles.first(where: { $0.path == selectedFile }) {
                updateFileToShow(file)
                return AnyView(FileView(viewFile: $fileToShow,
                                        errors: errors?[file.path], projectErrors: $errors,
                                        selectedProject: $selectedProject,
                                        projectInfo: $projectInfo, viewModel: FileViewModel(project: $selectedProject,
                                                                                            projectInfo: $projectInfo)))
            } else {
                return AnyView(Image(systemName: ""))
            }
        }
        
        func updateFileToShow(_ file: DFile) {
            DispatchQueue.main.async {
                self.fileToShow = file
            }
        }
    
    func saveContent(content: Content) {
        viewModel.contentDictionary[content.id] = content
    }
}

