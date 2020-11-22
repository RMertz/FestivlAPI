//
//  File.swift
//  
//
//  Created by Woody on 9/8/20.
//

import Vapor

struct WebSiteController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {

        try routes.register(collection: PublicFestivalController())
    }


}
