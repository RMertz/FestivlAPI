//
//  File.swift
//  
//
//  Created by Woody on 8/8/20.
//

import Vapor

struct Token: Codable {
    let value: String
}

extension Token: Content { }
