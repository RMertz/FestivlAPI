//
//  File.swift
//  
//
//  Created by Woody on 8/9/20.
//

import Vapor
import Fluent

protocol FestivalRepository: FestivlRepository {
    func getAllFestivals() throws -> EventLoopFuture<[Festival]>
    func createFestival(_ festival: Festival) throws -> EventLoopFuture<Festival>
    func getFestival(festivalName: String) throws -> EventLoopFuture<Festival>
    func getFestival(id: UUID) throws -> EventLoopFuture<Festival>
    //func createIteration(req: Request, festivalName: String) throws -> EventLoopFuture<FestivalIteration>
}

protocol RequiresFestivalRepository {
    var festivalRepository: FestivalRepository { get }
}
