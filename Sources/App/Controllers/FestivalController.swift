//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Vapor

struct FestivalController: RouteCollection {

    func boot(routes: RoutesBuilder) throws {
        let publicRoutes = routes.grouped("festival")
        let tokenProtected = publicRoutes.grouped(UserToken.authenticator())

        publicRoutes.get("all", use: getAllFestivals)
        publicRoutes.get(":name", use: getFestival)

        tokenProtected.post(use: createFestival)
    }

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
}
