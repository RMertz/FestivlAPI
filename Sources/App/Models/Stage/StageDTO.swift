//
//  StageDTO.swift
//  
//
//  Created by Woody on 8/7/20.
//

import Fluent
import Vapor

final class StageDTO: Model {
    static let schema: String = "stages"

    @ID()
    var id: UUID?

    @Field(key: .name)
    var name: String

    @Field(key: .color)
    var color: String

    @Field(key: .iconImageURL)
    var iconImageURL: String

    // MARK: Housekeeping
    @Timestamp(key: .createdAt, on: .create)
    var createdAt: Date?

    @Timestamp(key: .updatedAt, on: .update)
    var updatedAt: Date?

    @Timestamp(key: .deletedAt, on: .delete)
    var deletedAt: Date?

    init() {}

    init(id: UUID? = nil, name: String, color: String, iconImageURL: String) {
        self.id = id
        self.name = name
        self.color = color
        self.iconImageURL = iconImageURL
    }
}

extension StageDTO: Referencable {
    static var referenceKey: FieldKey = "stage_id"
}

extension FieldKey {
    static var color: Self = "color"
    static var iconImageURL: Self = "icon_image_url"
}
