//
//  ContentView.swift
//  diploma
//
//  Created by Evelina on 31.05.2024.
//

import Foundation
import SwiftUI

class AppViewModel: ObservableObject {
    @Published var showChooseProjectView = true
    @Published var projectName: String = "Default Project"
}

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var selectedProject: Project?
    @State private var projectErrors: Dictionary<String, [MetricErrorData]>?
    @State private var projectWarnings: Dictionary<String, [Warning]>?
    @State var projectInfo: ProjectInfo?
    @State var functionCalls: [FunctionExecutionTime]?
    
    var body: some View {
        if viewModel.showChooseProjectView {
            ChooseProjectView(appViewModel: viewModel, selectedProject: $selectedProject,
                              projectInfo: $projectInfo, errors: $projectErrors,
                              warnings: $projectWarnings, functionCalls: $functionCalls)
        } else {
            ProjectView(errors: $projectErrors, selectedProject: $selectedProject,
                        projectInfo: $projectInfo, warnings: $projectWarnings, 
                        functionCalls: $functionCalls)
        }
    }
}
