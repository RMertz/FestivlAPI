//
//  User.swift
//  
//
//  Created by Woody on 8/8/20.
//

import Fluent
import Vapor
import FestivlCore

final class User: Model, Content {
    static let schema = "users"

    @ID()
    var id: UUID?

    @Field(key: .email)
    var email: String

    @Field(key: .name)
    var name: String

    @Field(key: .passwordHash)
    var passwordHash: String

    // MARK: Housekeeping
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: .deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}

    init(id: UUID? = nil, email: String, passwordHash: String, name: String) {
      self.id = id
      self.email = email
      self.passwordHash = passwordHash
    }

    init(from signUp: UserSignup) throws {
        email = signUp.email // TODO: Lowercase?
        passwordHash = try Bcrypt.hash(signUp.password)
        name = signUp.name
    }
}

extension User: Referencable {
    static var referenceKey: FieldKey {
        return "user_id"
    }
}

// MARK: ModelAuthenticatable
extension User: ModelAuthenticatable {
    static var usernameKey = \User.$email
    static var passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User {
    func generateToken() throws -> UserToken {
        try  UserToken(
            value: [UInt8].random(count: 16).base64,
            userID: self.requireID()
        )
    }
}

extension FieldKey {
    static var username: Self = "username"
    static var passwordHash: Self = "password_hash"
    static var email: Self = "email"
}

// -MARK: Migrations
extension User {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(User.schema)
                .id()
                .field(.email, .string, .required)
                .unique(on: .email)
                .field(.name, .string, .required)
                .field(.passwordHash, .string, .required)
                .timeStampFields()
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(User.schema).delete()
        }
    }
}

extension Request {
    func user() throws -> User {
        return try self.auth.require(User.self)
    }
}
