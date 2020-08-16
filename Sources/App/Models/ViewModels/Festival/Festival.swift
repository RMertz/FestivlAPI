//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Vapor

struct Festival: Codable {
    let id: UUID?
    let name: String
    let urlName: String
    let iterations: [FestivalIteration]
}

extension Festival: Content {}

extension Festival {
    init(from dto: FestivalDTO) {
        self.id = dto.id
        self.name = dto.name
        self.urlName = dto.urlName
        self.iterations = dto.$iterations.eagerLoadedOrEmpty.map { FestivalIteration(from: $0) }
    }
}
