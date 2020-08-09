//
//  File.swift
//  
//
//  Created by Woody on 8/8/20.
//

import Vapor
import Fluent

struct UserSignup: Codable {
    let email: String
    let name: String
    let password: String
}

extension UserSignup: Content {}

extension UserSignup: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("name", as: String.self, is: !.empty)
        validations.add("password", as: String.self, is: .count(6...))
    }
}
