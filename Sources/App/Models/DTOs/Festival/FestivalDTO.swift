//
//  FestivalDTO.swift
//  
//
//  Created by Woody on 8/4/20.
//

import Fluent
import Vapor

final class FestivalDTO: Model {
    static let schema = "festivals"

    @ID()
    var id: UUID?

    @Field(key: .name)
    var name: String

    @Children(for: \.$festival)
    var iterations: [FestivalIterationDTO]

    // MARK: Housekeeping
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: .deletedAt, on: .delete)
    var deletedAt: Date?

    init() { }

    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

extension FestivalDTO: Referencable {
    static var referenceKey: FieldKey = "festival_id"
}

// MARK: Migrations
extension FestivalDTO {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(FestivalDTO.schema)
                .id()
                .field(.name, .string, .required)
                .timeStampFields()
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(FestivalDTO.schema).delete()
        }
    }
}

