//
//  File.swift
//  
//
//  Created by Woody on 9/8/20.
//

import Fluent

extension EventLoopFuture {
    public func flatMapThrowingFailedFuture<NewValue>(_ callback: @escaping (Value) throws -> EventLoopFuture<NewValue>) -> EventLoopFuture<NewValue> {
        return self.flatMap { (value: Value) -> EventLoopFuture<NewValue> in
            do {
                return try callback(value)
            } catch {
                return self.eventLoop.makeFailedFuture(error)
            }
        }
    }
}
