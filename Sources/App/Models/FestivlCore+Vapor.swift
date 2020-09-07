//
//  File.swift
//  
//
//  Created by Woody on 9/6/20.
//

import Foundation
import Vapor
import FestivlCore

// MARK: Festival
extension Festival: Content {}

extension Festival {
    init(from dto: FestivalDTO) throws {
        self.init(
            id: dto.id,
            name: dto.name,
            urlName: dto.urlName,
            iterations: try dto.$iterations.eagerLoadedOrEmpty.map { try FestivalIteration(from: $0) }
        )
    }
}

// MARK: FestivalIteration
extension FestivalIteration: Content {}

extension FestivalIteration {
    init(from dto: FestivalIterationDTO) throws {
        self.init(
            id: dto.id,
            festivalID: dto.$festival.id,
            urlName: dto.urlName,
            startDate: dto.startDate,
            endDate: dto.endDate,
            stages: dto.$stages.eagerLoadedOrEmpty.map { Stage(from: $0) }
        )
    }
}

// MARK: Stage
extension Stage: Content { }

extension Stage {
    init(from dto: StageDTO) {
        self.init(
            id: dto.id,
            name: dto.name,
            color: dto.color,
            iconImageURL: dto.iconImageURL
        )
    }
}

// MARK: Token
extension Token: Content { }

// MARK: UserSignUp

extension UserSignup: Content {}

extension UserSignup: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("name", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(6...))
    }
}

