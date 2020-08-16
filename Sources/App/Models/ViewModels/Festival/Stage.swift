//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Vapor

struct Stage: Codable {
    var id: UUID?
    var name: String
    var color: String
    var iconImageURL: String?
}

extension Stage: Content { }

extension Stage {
    init(from dto: StageDTO) {
        self.id = dto.id
        self.name = dto.name
        self.color = dto.color
        self.iconImageURL = dto.iconImageURL
    }
}
