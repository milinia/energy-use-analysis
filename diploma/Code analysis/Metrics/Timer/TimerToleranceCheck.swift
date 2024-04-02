//
//  TimerToleranceCheck.swift
//  diploma
//
//  Created by Evelina on 16.03.2024.
//

import Foundation
import SwiftSyntax

class TimerToleranceCheck: SyntaxVisitor {
    var timerVariableNames = Dictionary<String, Bool>()
        
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if node.description.contains("Timer.") {
            if let identifierPattern = node.bindings.first(where: { patternBindingSyntax in
                patternBindingSyntax.pattern.is(IdentifierPatternSyntax.self)
            })?.pattern.as(IdentifierPatternSyntax.self) {
                timerVariableNames[identifierPattern.identifier.text] = false
            }
        }
        return .visitChildren
    }
     
    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        if let key = node.base?.as(DeclReferenceExprSyntax.self)?.baseName.text, let value = timerVariableNames[key] {
            if node.declName.baseName.text == "tolerance"  {
                timerVariableNames[key] = true
            }
        }
        return .visitChildren
    }
}

