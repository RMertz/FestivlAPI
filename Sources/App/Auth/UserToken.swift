//
//  File.swift
//  
//
//  Created by Woody on 8/8/20.
//

import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "user_tokens"

    @ID()
    var id: UUID?

    @Field(key: .value)
    var value: String

    @Parent()
    var user: User

    // TODO: Probably needs an expiration date

    init() {}

    init(id: UUID? = nil, value: String, userID: User.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

extension FieldKey {
    static let value: Self = "value"
}

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey = \UserToken.$value
    static let userKey = \UserToken.$user

    var isValid: Bool {
        return true // TODO: ExpiryDate
    }
}

// MARK: Migrations
extension UserToken {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(UserToken.schema)
                .id()
                .field(.value, .string, .required)
                .field(
                    User.referenceKey,
                    .uuid,
                    .references(User.schema, .id)
                )
                .unique(on: .value)
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(UserToken.schema).delete()
        }
    }
}
