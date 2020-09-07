//
//  File.swift
//  
//
//  Created by Woody on 8/15/20.
//

import Fluent
import Foundation
import FestivlCore

protocol UserRolesRepository: FestivlRepository {
    func userRoleForFestivalID(user: User, festivalID: UUID) throws -> EventLoopFuture<UserRole>
    func createUserRoleRoleForFestival(user: User, festival: Festival, role: UserRole) throws -> EventLoopFuture<FestivalUserRole>
}
