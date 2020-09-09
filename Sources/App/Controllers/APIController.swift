//
//  File.swift
//  
//
//  Created by Woody on 9/8/20.
//

import Vapor

struct APIController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let apiRoutes = routes.grouped("api", "v1")

        try apiRoutes.register(collection: APIUserController())
        try apiRoutes.register(collection: APIFestivalController())
    }
}

