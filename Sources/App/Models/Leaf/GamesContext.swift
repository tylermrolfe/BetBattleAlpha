//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 3/6/21.
//

import Foundation
import Fluent
import Vapor

final class GamesContext: Content {
    let meta: PageMeta
    let games: [Game]
    
    init(meta: PageMeta, games: [Game]) {
        self.meta = meta
        self.games = games
    }
}
