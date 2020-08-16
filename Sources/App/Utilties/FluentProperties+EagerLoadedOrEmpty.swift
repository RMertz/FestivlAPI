//
//  FluentProperties+EagerLoadedOrEmpty.swift
//  
//
//  Created by Woody on 8/15/20.
//

import Fluent

extension ChildrenProperty {
    var eagerLoadedOrEmpty: [To] {
        return value ?? []
    }
}

extension SiblingsProperty {
    var eagerLoadedOrEmpty: [To] {
        return value ?? []
    }
}
