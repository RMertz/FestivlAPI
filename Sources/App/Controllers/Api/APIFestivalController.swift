//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Vapor
import FestivlCore

struct APIFestivalController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let publicRoutes = routes.grouped("festival")
        let tokenProtected = publicRoutes.grouped(UserToken.authenticator())

        publicRoutes.get("all", use: getAllFestivals)
        publicRoutes.get(":name", use: getFestival)
        publicRoutes.get(":name", ":iteration", use: getIterationBySlug)

        tokenProtected.post(use: createFestival)
        tokenProtected.post("iteration", use: createFestivalIteration)
    }

    // MARK: /festival/all
    private func getAllFestivals(req: Request) throws -> EventLoopFuture<[Festival]> {
        return try req.festivalRepository.getAllFestivals()
    }

    private func createFestival(req: Request) throws -> EventLoopFuture<Festival> {
        let festival = try req.content.decode(Festival.self)
        let user = try req.user()

        return try req.festivalRepository.createFestival(festival).flatMap { festival in
            do {
                return try req.userRolesRepository.createUserRoleRoleForFestival(user: user, festival: festival, role: .accountOwner)
                    .map { _ in festival }
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }
        }
    }

    private func getFestival(req: Request) throws -> EventLoopFuture<Festival> {
        guard let name = req.parameters.get("name") else { throw Abort(.badRequest) }

        return try req.festivalRepository.getFestival(festivalName: name)
    }

    private func createFestivalIteration(req: Request) throws -> EventLoopFuture<FestivalIteration> {
        let iteration = try req.content.decode(FestivalIteration.self)
        let user = try req.user()

        return try req.userRolesRepository.userRoleForFestivalID(user: user, festivalID: iteration.festivalID).flatMap { userRole -> EventLoopFuture<FestivalIteration> in

            do {
                guard userRole.mayCreateIterations else { throw Abort(.unauthorized) }
                return try req.festivalRepository.createIteration(iteration)
            } catch {
                return req.eventLoop.makeFailedFuture(error)
            }

        }
    }

    private func getIterationBySlug(req: Request) throws -> EventLoopFuture<FestivalIteration> {
        guard let festivalName = req.parameters.get("name"),
            let iteration = req.parameters.get("iteration") else { throw Abort(.badRequest) }


        return try req.festivalRepository.getIteration(festivalName: festivalName, iterationName: iteration)
    }

    private func getIterationByID(req: Request) throws -> EventLoopFuture<FestivalIteration> {
        guard let id = req.parameters.get("id"),
            let uuid = UUID(uuidString: id)
            else { throw Abort(.badRequest) }

        return try req.festivalRepository.getIteration(id: uuid)
    }
}
