//
//  Corrector.swift
//  diploma
//
//  Created by Evelina on 03.04.2024.
//

import Foundation

protocol Corrector {
    func correct(error: MetricErrorData, fileOffset: Dictionary<String, Int>) -> Int
}
