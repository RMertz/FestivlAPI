//
// ORMUserRolesRepository.swift
//  
//
//  Created by Woody on 8/15/20.
//

import Vapor
import Fluent
import FestivlCore

struct ORMUserRolesRepository: UserRolesRepository {
    let req: Request

    func `for`(_ request: Request) -> ORMUserRolesRepository {
        return ORMUserRolesRepository(req: request)
    }

    func userRoleForFestivalID(user: User, festivalID: UUID) throws -> EventLoopFuture<UserRole> {
        try FestivalUserRole.query(on: req.db)
            .with(\.$festival)
            .with(\.$user)
            .filter(\.$festival.$id == festivalID)
            .filter(\.$user.$id == user.requireID())
            .first()
            .map { userRole in
                return userRole?.role ?? .notAuthorized
            }
    }

    func createUserRoleRoleForFestival(user: User, festival: Festival, role: UserRole) throws -> EventLoopFuture<FestivalUserRole> {
        let role = try FestivalUserRole(festival: FestivalDTO(from: festival), user: user, role: role)

        return role.create(on: req.db).map { role }
    }
}
