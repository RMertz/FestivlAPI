//
//  File.swift
//  
//
//  Created by Woody on 8/7/20.
//

import Fluent
import Vapor

final class ArtistDTO: Model {
    static let schema: String = "artist"

    @ID()
    var id: UUID?

    @Field(key: .name)
    var name: String

    @Field(key: .description)
    var description: String

    @Parent()
    var festivalIteration: FestivalIterationDTO

    /// The tier the artist is in the lineup, highest being 0. This will affect things like the visibility in the "explore" page
    /// A nil value will not be displayed on explore
    @Field(key: .tier)
    var tier: Int?

    @Field(key: .soundcloudURL)
    var soundcloudURL: String?

    @Field(key: .websiteURL)
    var websiteURL: String?

    @Field(key: .spotifyURL)
    var spotifyURL: String?

    // MARK: Housekeeping
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: .deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}

    init(id: UUID? = nil, name: String, description: String, tier: Int?, soundCloudURL: String?, websiteURL: String?, spotifyURL: String?, festivalIteration: FestivalIterationDTO) throws {
        self.id = id
        self.name = name
        self.description = description
        self.tier = tier
        self.soundcloudURL = soundCloudURL
        self.websiteURL = websiteURL
        self.spotifyURL = spotifyURL
        self.$festivalIteration.id = try festivalIteration.requireID()
    }
}

extension ArtistDTO: Referencable {
    static var referenceKey: FieldKey = "artist_id"
}

extension FieldKey {
    static var tier: Self = "tier"
    static var soundcloudURL: Self = "soundcloud_url"
    static var websiteURL: Self = "website_url"
    static var spotifyURL: Self = "spotify_url"
}


struct CreateArtist: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(ArtistDTO.schema)
            .id()
            .field(.name, .string, .required)
            .field(.description, .string, .required)
            .field(.tier, .int8)
            .field(.soundcloudURL, .string)
            .field(.websiteURL, .string)
            .field(.spotifyURL, .string)
            .field(
                FestivalDTO.referenceKey,
               .uuid,
               .references(FestivalIterationDTO.schema, .id),
               .required
            )
            .timeStampFields()
            .create()

    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(ArtistDTO.schema).delete()
    }
}
