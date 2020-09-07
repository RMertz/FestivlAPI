//
//  File.swift
//  
//
//  Created by Woody on 8/15/20.
//

import Vapor
import Fluent
import FestivlCore

struct ORMFestivalRepository: FestivalRepository {

    let req: Request

    func `for`(_ request: Request) -> ORMFestivalRepository {
        return ORMFestivalRepository(req: request)
    }

    func getAllFestivals() throws -> EventLoopFuture<[Festival]> {
        return FestivalDTO.query(on: req.db)
            .all()
            .flatMapThrowing { dtos in
                try dtos.map { try Festival(from: $0) }
            }
    }

    func createFestival(_ festival: Festival) throws -> EventLoopFuture<Festival> {
        let dto = FestivalDTO(from: festival)

        return dto.create(on: req.db)
            .flatMapThrowing { try Festival(from: dto) }
    }

    func getFestival(festivalName: String) throws -> EventLoopFuture<Festival> {
        return FestivalDTO.query(on: req.db)
            .with(\.$iterations)
            .filter(\.$urlName == festivalName)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing {
                try Festival(from: $0)
            }
    }

    func getFestival(id: UUID) throws -> EventLoopFuture<Festival> {
        return FestivalDTO
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing {
                try Festival(from: $0)
            }
    }

    // MARK: - Iteration
    func createIteration(_ iteration: FestivalIteration) throws -> EventLoopFuture<FestivalIteration> {
        let dto = try FestivalIterationDTO(from: iteration)
        return dto.create(on: req.db)
            .flatMapThrowing { try FestivalIteration(from: dto) }
    }

    func getIteration(festivalName: String, iterationName: String) throws -> EventLoopFuture<FestivalIteration> {
        return FestivalIterationDTO.query(on: req.db)
            .filter(\.$urlName == iterationName)
            .join(FestivalDTO.self, on: \FestivalIterationDTO.$festival.$id == \FestivalDTO.$id)
            .filter(FestivalDTO.self, \.$urlName == festivalName)
            .filter(FestivalIterationDTO.self, \.$urlName == iterationName)
            .with(\.$festival)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing {
                try FestivalIteration(from: $0)
            }
    }

    func getIteration(id: UUID) throws -> EventLoopFuture<FestivalIteration> {
        FestivalIterationDTO
            .find(id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing {
                try FestivalIteration(from: $0)
            }
    }
}
