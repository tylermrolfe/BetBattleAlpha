//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 7/24/20.
//

import Fluent
import Vapor
import Foundation

final class League: Model, Content {
    static let schema = "leagues"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "key")
    var key: String
    
    @Field(key: "active")
    var active: Bool
    
    init() { }
    
    init(key: String, active: Bool) {
        self.key = key
        self.active = active
    }
}
