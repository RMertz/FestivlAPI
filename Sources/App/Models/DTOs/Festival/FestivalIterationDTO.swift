//
//  FestivalIterationDTO.swift
//  
//
//  Created by Woody on 8/7/20.
//

import Fluent
import Vapor
import FestivlCore

/// An single happening of a event, usually yearly.
final class FestivalIterationDTO: Model {
    static let schema: String = "festival_iterations"

    @ID()
    var id: UUID?

    @Field(key: .urlName)
    var urlName: String

    /// The start date of the sets of the festival
    @Field(key: .startDate)
    var startDate: Date

    /// The end date of the sets of the festival
    @Field(key: .endDate)
    var endDate: Date

    @Parent()
    var festival: FestivalDTO

    @Siblings(through: StageFestivalIterationPivot.self, from: \.$festivalIteration, to: \.$stage)
    var stages: [StageDTO]

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

    init(from viewModel: FestivalIteration) throws {
        self.id = viewModel.id
        self.urlName = viewModel.urlName
        self.startDate = viewModel.startDate
        self.endDate = viewModel.endDate
        self.$festival.id = viewModel.festivalID
    }
}

extension FestivalIterationDTO: Referencable {
    static var referenceKey: FieldKey = "festival_iteration_id"
}

extension FestivalIterationDTO {
    struct Migration: Fluent.Migration {
        func prepare(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(FestivalIterationDTO.schema)
                .id()
                .field(.urlName, .string, .required)
                .field(.startDate, .datetime, .required)
                .field(.endDate, .datetime, .required)
                .field(
                    FestivalDTO.referenceKey,
                    .uuid,
                    .references(FestivalDTO.schema, .id),
                    .required
                )
                .timeStampFields()
                .unique(on: FestivalDTO.referenceKey, .urlName) // Each festival can't have multiple iterations named the same thing, so we can reference like /festivalName/2020/
                .create()
        }

        func revert(on database: Database) -> EventLoopFuture<Void> {
            return database.schema(FestivalIterationDTO.schema).delete()
        }
    }
}

