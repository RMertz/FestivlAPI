//
//  File.swift
//  
//
//  Created by Woody on 8/15/20.
//

import Fluent

protocol UserRolesRepository: FestivlRepository {
    func userRoleForFestival(user: User, festival: Festival) throws -> EventLoopFuture<UserRole>
    func createUserRoleRoleForFestival(user: User, festival: Festival, role: UserRole) throws -> EventLoopFuture<FestivalUserRole>
}
