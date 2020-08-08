//
//  TimestampFields.swift
//  
//
//  Created by Woody on 8/8/20.
//

import Fluent

extension SchemaBuilder {
    func timeStampFields() -> Self {
        self.field(.definition(name: .key(.createdAt), dataType: .datetime, constraints: []))
            .field(.definition(name: .key(.updatedAt), dataType: .datetime, constraints: []))
            .field(.definition(name: .key(.deletedAt), dataType: .datetime, constraints: []))
    }
}
