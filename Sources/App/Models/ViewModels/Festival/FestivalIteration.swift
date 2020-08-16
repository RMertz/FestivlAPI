//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Vapor
import Fluent

struct FestivalIteration: Codable {
    let id: UUID?
    let festivalID: UUID?
    let urlName: String
    let startDate: Date
    let endDate: Date
    let stages: [Stage]
}

extension FestivalIteration: Content {}

extension FestivalIteration {
    init(from dto: FestivalIterationDTO) {
        self.id = dto.id
        self.festivalID = dto.festival.id
        self.urlName = dto.urlName
        self.startDate = dto.startDate
        self.endDate = dto.endDate

        self.stages = dto.$stages.eagerLoadedOrEmpty.map { Stage(from: $0) }
    }
}
