//
//  ProjectTraverser.swift
//  diploma
//
//  Created by Evelina on 25.01.2024.
//

import Foundation

protocol ProjectTraverser {
//    func traverse(project: Project)
}

class ProjectTraverserImpl: ProjectTraverser {
    
    private var checkedFiles: [File] = []
    let errors: Dictionary<String, [MetricErrorData]> = [:]
    
    func traverse(files: [File]) -> Dictionary<String, [MetricErrorData]> {
        checkedFiles = files
        let fileTraverser = FileTraverser()
        while !(checkedFiles.isEmpty) {
            let file = checkedFiles.removeFirst()
            fileTraverser.traverseFile(file: file)
        }
        return errors
    }
}
