//
//  File.swift
//  
//
//  Created by Woody on 8/7/20.
//

import Foundation
import Fluent

extension FieldKey {
    // MARK: Common
    static var name: Self = "name"
    static var description: Self = "description"

    // MARK: Times
    static var startTime: Self = "start_time"
    static var endTime: Self = "end_time"

    static var startDate: Self = "start_date"
    static var endDate: Self = "end_date"

    // MARK: Housekeeping
    static var createdAt: Self = "created_at"
    static var updatedAt: Self = "updated_at"
    static var deletedAt: Self = "deleted_at"
}
