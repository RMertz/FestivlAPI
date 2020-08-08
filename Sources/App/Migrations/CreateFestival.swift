//
//  File.swift
//  
//
//  Created by Woody on 8/7/20.
//

import Fluent

struct CreateFestival: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(FestivalDTO.schema)
            .id()
            .field(FestivalDTO().$name.key, .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(FestivalDTO.schema).delete()
    }
}

