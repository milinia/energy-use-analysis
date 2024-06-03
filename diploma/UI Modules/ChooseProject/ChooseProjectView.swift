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
    @Binding var selectedProject: Project?
    @Binding var errors: Dictionary<String, [MetricErrorData]>?
    
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
                            viewModel.readProject(path: pickedFolder, selectedProject: $selectedProject, errors: $errors) {
                                appViewModel.showChooseProjectView = false
                            }
                        }
                    }
                }
            } else {
                Text("Project is being analyzed")
                VStack {
                    ProgressView()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
