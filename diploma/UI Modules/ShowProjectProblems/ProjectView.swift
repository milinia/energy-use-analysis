//
//  ProjectView.swift
//  diploma
//
//  Created by Evelina on 13.12.2023.
//

import SwiftUI

struct ProjectView: View {

    var project: Project?
    var errors: Dictionary<String, [MetricErrorData]>?
    @State private var selectedContent: Content.ID?
    @StateObject var viewModel = ProjectViewModel()

    init(project: Project?, errors: Dictionary<String, [MetricErrorData]>?) {
        self.project = project
        self.errors = errors
    }

    var body: some View {
        if let project = project {
            NavigationSplitView {
                List(project.content, children: \.content, selection: $selectedContent) { item in
                    let isHasError = errors?[item.path] != nil
                    ContentRow(contentData: ContentRowData(content: item, isHasError: isHasError))
                        .onAppear {
                            saveContent(content: item)
                        }
                }
            } detail: {
                let element = viewModel.contentDictionary[selectedContent ?? UUID()]
                switch element {
                case let file as DFile:
                    FileView(file: file, errors: errors?[file.path])
                default: Image(systemName: "")
                }
            }
        } else {
            Text("This project unavailable")
        }
    }
    
    func saveContent(content: Content) {
        viewModel.contentDictionary[content.id] = content
    }
}

//struct ProjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProjectView(project: Project(name: "App",
//                                     content: [File(path: "AppDelegete.swift", type: .swift, data: "djvndjvnd".data(using: .utf8) ?? Data()),
//                                               Folder(path: "AppFolder",
//                                                      content: [File(path: "StartView.swift", type: .swift, data: "djvndjfvfvfv vfvfvfvfv vfvfvfvfv vfvfvfvfvfv fvfvfvfv vnd".data(using: .utf8) ?? Data())])], path: URL(fileURLWithPath: "")))
//    }
//}

