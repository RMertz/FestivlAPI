//
//  File.swift
//  
//
//  Created by Woody on 8/15/20.
//

import Vapor
import Fluent

struct ORMFestivalRepository: FestivalRepository {
    let req: Request

    func `for`(_ request: Request) -> ORMFestivalRepository {
        return ORMFestivalRepository(req: request)
    }

    func getAllFestivals() throws -> EventLoopFuture<[Festival]> {
        return FestivalDTO.query(on: req.db)
            .all()
            .map { dtos in
                dtos.map { Festival(from: $0) }
            }
    }

    func createFestival(_ festival: Festival) throws -> EventLoopFuture<Festival> {
        let dto = FestivalDTO(from: festival)

        return dto.create(on: req.db)
            .map { Festival(from: dto) }
    }

    func getFestival(festivalName: String) throws -> EventLoopFuture<Festival> {
        return FestivalDTO.query(on: req.db)
            .filter(\.$name == festivalName)
            .first()
            .unwrap(or: Abort(.notFound))
            .map {
                Festival(from: $0)
            }
    }

    func getFestival(id: UUID) throws -> EventLoopFuture<Festival> {
        return FestivalDTO.query(on: req.db)
            .filter(\.$id == id)
            .first()
            .unwrap(or: Abort(.notFound))
            .map {
                Festival(from: $0)
            }
    }
}
