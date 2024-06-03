//
//  diplomaApp.swift
//  diploma
//
//  Created by Evelina on 04.12.2023.
//

import SwiftUI

@main
struct diplomaApp: App {
    @StateObject private var viewModel = AppViewModel()
    @State private var selectedProject: Project?
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
