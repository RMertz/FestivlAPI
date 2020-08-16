//
//  FestivlRepository.swift
//  
//
//  Created by Woody on 8/16/20.
//

import Vapor

protocol FestivlRepository {
    func `for`(_ request: Request) -> Self
}


