//
//  Request+Repositories.swift
//  
//
//  Created by Woody on 8/16/20.
//

import Vapor

// TODO: Dependency inject these somehow
extension Request {
    var userRolesRepository: UserRolesRepository {
        ORMUserRolesRepository(req: self)
    }

    var festivalRepository: FestivalRepository {
        ORMFestivalRepository(req: self)
    }
}
