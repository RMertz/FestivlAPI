//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Vapor
import Fluent

struct FestivalRepository {
    func getAllFestivals(req: Request) throws -> EventLoopFuture<[Festival]> {
        FestivalDTO.query(on: req.db).all().map { dtos in
            dtos.map { Festival(from: $0) }
        }
    }

    func createFestival(req: Request) throws -> EventLoopFuture<Festival> {
        let viewModel = try req.content.decode(Festival.self)
        let user = try req.auth.require(User.self)

        let dto = FestivalDTO(from: viewModel)

        return dto.create(on: req.db).flatMap {
            do {
                // dto is a class, so that object will get updated with the id
                let userRole = try FestivalUserRoles(festival: dto, user: user, role: .accountOwner)
                return userRole.save(on: req.db)
                    .map { Festival(from: dto) }
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }

    func getFestival(req: Request, festivalName: String) throws -> EventLoopFuture<Festival> {
        return FestivalDTO.query(on: req.db)
            .filter(\.$urlName == festivalName)
            .with(\.$iterations, { $0.with(\.$stages)})
            .first()
            .unwrap(or: Abort(.notFound))
            .map { Festival(from: $0) }
    }
}
