//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 2/25/21.
//


import Foundation
import Vapor
import Fluent

final class GameEntry: Model, Content {
    static let schema = "gameEntries"
    
    let game: Game?
    
}
