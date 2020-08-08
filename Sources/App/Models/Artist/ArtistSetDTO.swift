//
//  File.swift
//  
//
//  Created by Woody on 8/7/20.
//

import Fluent
import Vapor

final class ArtistSetDTO: Model {
    static let schema: String = "artist_sets"

    @ID()
    var id: UUID?

    @Parent()
    var artist: ArtistDTO

    @Parent()
    var stage: StageDTO

    @Field(key: .startTime)
    var startTime: Date

    @Field(key: .endTime)
    var endTime: Date

    // MARK: Housekeeping
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: .deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}

    init(id: UUID? = nil, artist: ArtistDTO, stage: StageDTO, startTime: Date, endTime: Date) throws {
        self.id = id
        self.$artist.id = try artist.requireID()
        self.$stage.id = try stage.requireID()
        self.startTime = startTime
        self.endTime = endTime
    }
}

extension FieldKey {
    static var artistID: Self = "artist_id"
    static var stageID: Self = "stage_id"
}
