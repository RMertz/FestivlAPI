//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Fluent
import Vapor

enum UserRole: String, Codable {
    static var schema = "user_role"

    case accountOwner
    case editor
    case notAuthorized // Not stored in database
}

extension UserRole {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.enum(UserRole.schema)
                .case(UserRole.accountOwner.rawValue)
                .case(UserRole.editor.rawValue)
                .create().map { _ in }
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.enum(UserRole.schema).delete()
        }
    }
}

// MARK: Abilities
extension UserRole {
    var mayCreateIterations: Bool {
        switch self {
        case .accountOwner, .editor:
            return true
        case .notAuthorized:
            return false
        }
    }
}
