//
//  File.swift
//  
//
//  Created by Woody on 9/8/20.
//

import Vapor
import FestivlCore

struct PublicFestivalController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {

        routes.get(":festival", use: festivalDetails)
        routes.get(":festival", ":iteration", use: iterationDeatils)
    }

    private func festivalDetails(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Codable {
            var festival: Festival
        }

        guard let festivalName = req.parameters.get("festival") else { throw Abort(.badRequest) }


        return try req.festivalRepository.getFestival(festivalName: festivalName).flatMapThrowingFailedFuture {
            req.view.render("festivalDetails", Context(festival: $0))
        }
    }

    private func iterationDeatils(req: Request) throws -> EventLoopFuture<View> {
        struct Context: Codable {
            var festival: Festival
            var iteration: FestivalIteration
        }

        guard let festivalName = req.parameters.get("festival") else { throw Abort(.badRequest) }
        guard let iterationName = req.parameters.get("iteration") else { throw Abort(.badRequest) }

        return try req.festivalRepository.getIteration(festivalName: festivalName, iterationName: iterationName)
            .and(req.festivalRepository.getFestival(festivalName: festivalName))
            .flatMapThrowingFailedFuture { iteration, festival in
                req.view.render("iterationDetails", Context(festival: festival, iteration: iteration))
        }
    }
}
