//
//  AppError.swift
//  diploma
//
//  Created by Evelina on 06.12.2023.
//

import Foundation

enum AppError: Error {
    case emptyFolder
    case noSuchFolder
    case cannotReadFile
}
