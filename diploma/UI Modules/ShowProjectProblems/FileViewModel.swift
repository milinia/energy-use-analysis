//
//  FileViewModel.swift
//  diploma
//
//  Created by Evelina on 17.02.2024.
//

import Foundation
import SwiftUI

final class ProjectViewModel: ObservableObject {
    var contentDictionary: Dictionary<UUID, Content> = [:]
}

final class FileViewModel: ObservableObject {
    
    let project: Binding<Project?>
    let projectInfo: Binding<ProjectInfo?>
    private var errorCorrector: ErrorCorrector
    private var filesOffset: Dictionary<String, Int> = [:]
    
    init(project: Binding<Project?>, projectInfo: Binding<ProjectInfo?>) {
        self.project = project
        self.projectInfo = projectInfo
        self.errorCorrector = ErrorCorrector(delegates: projectInfo.wrappedValue?.delegates ?? [:],
                                             classes: projectInfo.wrappedValue?.classNames ?? [],
                                             projectInfo: projectInfo.wrappedValue)
    }
    
    
    func fixError(file: DFile, error: MetricErrorData, completion: @escaping (DFile) -> Void) {
        // исправление ошибки
        var newOffset = 0
        if let errorType = error.type as? ComputeTask {
            if let functionCall = error.functionCall {
                newOffset = errorCorrector.correctFunctionCall(functionCall: functionCall, fileOffset: filesOffset)
            }
        } else {
            newOffset = errorCorrector.correctError(error: error, fileOffset: filesOffset)
        }
        if let offset = filesOffset[file.path] {
            filesOffset[file.path] = offset + newOffset
        }
        FileSaver.saveFile(file: file)
        completion(file)
    }
}
