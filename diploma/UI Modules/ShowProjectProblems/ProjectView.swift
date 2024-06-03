//
//  ProjectView.swift
//  diploma
//
//  Created by Evelina on 13.12.2023.
//

import SwiftUI

struct ProjectView: View {
    
    @Binding var errors: Dictionary<String, [MetricErrorData]>?
    @State private var selectedContent: Content.ID?
    @State private var selectedError: Content.ID?
    @Binding var selectedProject: Project?
    @StateObject var viewModel = ProjectViewModel()
    @State private var isProjectShowing: Bool = true
    @State private var isButtonPressed = false
    
    var body: some View {
        if let project = selectedProject {
            NavigationSplitView {
                Divider()
                HStack {
                    Spacer()
                    Button(action: {
                        isProjectShowing = true
                    }) {
                        Image(systemName: "folder.fill")
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        isProjectShowing = false
                    }) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        //затратные операции
                    }) {
                        Image(systemName: "list.bullet.rectangle")
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                }
                .padding(.vertical, 1)
                Divider()
                if isProjectShowing {
                    List(project.content, children: \.content, selection: $selectedContent) { item in
                        let isHasError = errors?[item.path] != nil
                        ContentRow(contentData: ContentRowData(content: item, isHasError: isHasError))
                        .onAppear {
                            saveContent(content: item)
                        }
//                        if isHasError {
//                            
//                        }
                    }
                } else {
                    List {
                        ForEach(errors?.keys.sorted() ?? [], id: \.self) { key in
                            Section(header: Text(key.relativePath ?? "")) {
                                ForEach(errors?[key] ?? []) { error in
                                    Text(error.type.errorMessage)
                                }
                            }
                        }
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

