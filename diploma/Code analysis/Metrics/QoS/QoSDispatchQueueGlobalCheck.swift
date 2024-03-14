//
//  QoSDispatchQueueGlobalCheck.swift
//  diploma
//
//  Created by Evelina on 13.03.2024.
//

import Foundation
import SwiftSyntax

class QoSDispatchQueueGlobalCheck: SyntaxVisitor {
    
    func visit(_node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }
    
    func visit(_node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        if let calledExpression = _node.calledExpression as? MemberAccessExprSyntax {
            if let declExpression = calledExpression.base as? DeclReferenceExprSyntax {
                print(declExpression)
            }
        }
        
        return .skipChildren
    }
}
