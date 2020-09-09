//
//  File.swift
//  
//
//  Created by Woody on 8/8/20.
//

import Vapor
import FestivlCore

struct APIUserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let publicRoutes = routes.grouped("user")
        let passwordProtected = publicRoutes.grouped(User.authenticator())
        let tokenProtected = publicRoutes.grouped(UserToken.authenticator())


        publicRoutes.post("signup", use: signup)

        passwordProtected.post("signin", use: login)

        tokenProtected.get("me", use: getLoggedInUser)
    }

    private func signup(req: Request) throws -> EventLoopFuture<User> {
        try UserSignup.validate(content: req)
        let userSignUp = try req.content.decode(UserSignup.self)

        let user = try User(from: userSignUp)

        return user.save(on: req.db)
            .map { user }
    }

    private func login(req: Request) throws -> EventLoopFuture<UserToken> {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()

        return token.save(on: req.db)
            .map { token }
    }

    private func getLoggedInUser(req: Request) throws -> User {
        try req.auth.require(User.self)
    }
}
