//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Vapor

struct FestivalController: RouteCollection {
    let repository = FestivalRepository()

    func boot(routes: RoutesBuilder) throws {
        let publicRoutes = routes.grouped("festival")
        let tokenProtected = publicRoutes.grouped(UserToken.authenticator())

        publicRoutes.get("all", use: getAllFestivals)
        publicRoutes.get(":name", use: getFestival)

        tokenProtected.post(use: createFestival)
    }

    private func getAllFestivals(req: Request) throws -> EventLoopFuture<[Festival]> {
        return try repository.getAllFestivals(req: req)
    }

    private func createFestival(req: Request) throws -> EventLoopFuture<Festival> {
        return try repository.createFestival(req: req)
    }

    private func getFestival(req: Request) throws -> EventLoopFuture<Festival> {
        guard let name = req.parameters.get("name") else { throw Abort(.badRequest) }

        return try repository.getFestival(req: req, festivalName: name)
    }
}
