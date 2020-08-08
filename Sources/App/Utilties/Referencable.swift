//
//  Referencable.swift
//  
//
//  Created by Woody on 8/7/20.
//

import Foundation
import Fluent

protocol Referencable {
    static var referenceKey: FieldKey { get }
}

// Make a parent use the reference key of it's parents type
extension ParentProperty where Value: Referencable {
    convenience init() {
        self.init(key: Value.referenceKey)
    }
}
