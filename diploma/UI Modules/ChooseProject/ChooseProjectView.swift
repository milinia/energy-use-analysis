//
//  ChooseProjectView.swift
//  diploma
//
//  Created by Evelina on 04.12.2023.
//

import SwiftUI

struct ChooseProjectView: View {
    @StateObject var viewModel = ChooseProjectViewModel()
    @ObservedObject var appViewModel: AppViewModel
    @State var isProjectAnalysing: Bool = false
    @State var isCodeGenerated: Bool = false
    @Binding var selectedProject: Project?
    @Binding var projectInfo: ProjectInfo?
    @Binding var errors: Dictionary<String, [MetricErrorData]>?
    @Binding var warnings: Dictionary<String, [Warning]>?
    @Binding var functionCalls: [FunctionExecutionTime]?
    
    var body: some View {
        VStack {
            if !isProjectAnalysing {
                Button("Select project") {
                    let folderChooserPoint = CGPoint(x: 0, y: 0)
                    let folderChooserSize = CGSize(width: 500, height: 600)
                    let folderChooserRectangle = CGRect(origin: folderChooserPoint, size: folderChooserSize)
                    let folderPicker = NSOpenPanel(contentRect: folderChooserRectangle, styleMask: .utilityWindow, backing: .buffered, defer: true)
                    folderPicker.canChooseDirectories = true
                    folderPicker.canChooseFiles = false
                    folderPicker.allowsMultipleSelection = false
                    folderPicker.canDownloadUbiquitousContents = true
                    folderPicker.canResolveUbiquitousConflicts = true
                    folderPicker.begin { response in
                        if response == .OK {
                            let pickedFolder = folderPicker.urls[0]
                            isProjectAnalysing = true
                            viewModel.readProject(path: pickedFolder, 
                                                  selectedProject: $selectedProject,
                                                  projectInfo: $projectInfo
                            ) {
                                isCodeGenerated = true
                            }
                        }
                    }
                }
            } else {
                if !isCodeGenerated {
                    Text("Project is being analyzed")
                    VStack {
                        ProgressView()
                    }
                } else {
                    VStack(spacing: 10) {
                        Text("Open project folder and enter to folder Test")
                        Text("Then open terminal and run \"sh script.sh\"")
                        Text("Then run created project and test that you want to check")
                        Button("Done") {
                            isProjectAnalysing = true
                            isCodeGenerated = false
                            viewModel.findProjectErrors(errors: $errors, projectInfo: $projectInfo, warnings: $warnings, functionCalls: $functionCalls) {
                                appViewModel.showChooseProjectView = false
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
