//
//  FestivalIterationDTO.swift
//  
//
//  Created by Woody on 8/7/20.
//

import Fluent
import Vapor

/// An single happening of a festival, usually yearly.
final class FestivalIterationDTO: Model {
    static let schema: String = "festival_iterations"

    @ID()
    var id: UUID?

    /// The start date of the "Events" of the festival
    @Field(key: .startDate)
    var startDate: Date

    /// The end date of the "Events" of the festival
    @Field(key: .endDate)
    var endDate: Date

    @Parent()
    var festival: FestivalDTO

    // MARK: Housekeeping
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: .deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}

    init(id: UUID? = nil, festival: FestivalDTO, startDate: Date, endDate: Date) throws {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.$festival.id = try festival.requireID()
    }
}

extension FestivalIterationDTO: Referencable {
    static var referenceKey: FieldKey = "festival_iteration_id"
}

struct CreateFestivalIteration: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(FestivalIterationDTO.schema)
            .id()
            .field(.startDate, .datetime, .required)
            .field(.endDate, .datetime, .required)
            .field(
                FestivalDTO.referenceKey,
                .uuid,
                .references(FestivalDTO.schema, .id),
                .required
            )
            .timeStampFields()
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(FestivalIterationDTO.schema).delete()
    }
}
