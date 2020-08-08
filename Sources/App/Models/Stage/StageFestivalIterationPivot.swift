//
//  FestivalStageIteration.swift
//  FestivlAPI
//
//  Created by Woody on 8/7/20.
//

import Fluent
import Vapor

final class StageFestivalIterationPivot: Model {
    static let schema: String = "stage+festival_iteration"

    @ID()
    var id: UUID?

    @Parent()
    var stage: StageDTO

    @Parent()
    var festivalIteration: FestivalIterationDTO

    // MARK: Housekeeping
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: .deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}

    init(id: UUID? = nil, stage: StageDTO, festivalIteration: FestivalIterationDTO) throws {
        self.id = id
        self.$stage.id = try stage.requireID()
        self.$festivalIteration.id = try stage.requireID()
    }
}

struct CreateStageFestivalIterationPivot: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {

        database.schema(StageFestivalIterationPivot.schema)
            .id()
            .field(
                StageDTO.referenceKey,
                .uuid,
                .references(StageDTO.schema, .id),
                .required
            )
            .field(
                FestivalIterationDTO.referenceKey,
                .uuid,
                .references(FestivalIterationDTO.schema, .id),
                .required
            )
            .timeStampFields()
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(StageFestivalIterationPivot.schema).delete()
    }
}
