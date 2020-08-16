//
// ORMUserRolesRepository.swift
//  
//
//  Created by Woody on 8/15/20.
//

import Vapor
import Fluent

struct ORMUserRolesRepository: UserRolesRepository {
    let req: Request

    func `for`(_ request: Request) -> ORMUserRolesRepository {
        return ORMUserRolesRepository(req: request)
    }

    func userRoleForFestival(user: User, festival: Festival) throws -> EventLoopFuture<UserRole> {
        try FestivalUserRole.query(on: req.db)
            .filter(\.festival.$id == FestivalDTO(from: festival).requireID())
            .filter(\.user.$id == user.requireID())
            .first()
            .map { userRole in
                return userRole?.role ?? .notAuthorized
            }
    }

    func createUserRoleRoleForFestival(user: User, festival: Festival, role: UserRole) throws -> EventLoopFuture<FestivalUserRole> {
        let role = try FestivalUserRole(festival: FestivalDTO(from: festival), user: user, role: role)

        return try role.create(on: req.db).map {
            role
        }
    }
}
