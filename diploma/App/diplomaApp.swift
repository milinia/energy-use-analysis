//
//  diplomaApp.swift
//  diploma
//
//  Created by Evelina on 04.12.2023.
//

import SwiftUI

@main
struct diplomaApp: App {
    
    var body: some Scene {
        WindowGroup {
            ChooseProjectView()
        }
        
//        WindowGroup("Project", id: "project", for: ProjectErrors.self) { project in
//            ProjectView(project: project.wrappedValue?.project, errors: project.wrappedValue?.errors)
//        }
//        .commandsRemoved()
//        .defaultSize(<#T##size: CGSize##CGSize#>)
    }
}
