//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 1/1/21.
//

import Foundation
import Vapor
import Fluent

final class Contest: Model, Content {
    static let schema = "contests"
    
    @ID(key: .id)
    var id: UUID?
    
    
}
