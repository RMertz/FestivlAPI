//
//  FestivalUserRoles.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Fluent
import Vapor

final class FestivalUserRole: Model {
    static let schema = "festival+user+roles"

    @ID()
    var id: UUID?

    @Parent()
    var user: User

    @Parent()
    var festival: FestivalDTO

    @Field(key: .role)
    var role: UserRole


    init() {}

    init(id: UUID? = nil, festival: FestivalDTO, user: User, role: UserRole) throws {
        self.id = id
        self.$festival.id = try festival.requireID()
        self.$user.id = try user.requireID()
        self.role = role
    }
}

extension FieldKey {
    static var role: Self = "role"
}

extension FestivalUserRole {
    struct Migration: Fluent.Migration {

        func prepare(on database: Database) -> EventLoopFuture<Void> {
            database.schema(FestivalUserRole.schema)
                .id()
                .field(.role, .string, .required)
                .field(
                    User.referenceKey,
                    .uuid,
                    .references(User.schema, .id),
                    .required
                )
                .field(
                    FestivalDTO.referenceKey,
                    .uuid,
                    .references(FestivalDTO.schema, .id),
                    .required
                )
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            database.schema(FestivalUserRole.schema).delete()
        }
    }

}
