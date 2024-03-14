//
//  ChooseProjectView.swift
//  diploma
//
//  Created by Evelina on 04.12.2023.
//

import SwiftUI

struct ChooseProjectView: View {
    @Environment(\.openWindow) private var openWindow
    @StateObject var viewModel = ChooseProjectViewModel()

    var body: some View {
        HStack {
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
                        viewModel.readProject(path: pickedFolder, comletionHandler: { projectError in
                            openWindow(id: "project", value: projectError)
                        })
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
//    func openProjectWindow(project: Project) {
//        openWindow(id: "project")
//    }
}

//struct ChooseProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseProjectView()
//    }
//}
