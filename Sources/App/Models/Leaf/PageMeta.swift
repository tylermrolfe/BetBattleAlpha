//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 3/2/21.
//

import Foundation
import Fluent
import Vapor

final class PageMeta: Content {
    let title: String
    let meta: String
    let canonical: String?
    
    init(title: String, meta: String, canonical: String?) {
        self.title = title
        self.meta = meta
        self.canonical = canonical
    }
}

struct Pages: Content {
    static let home = PageMeta(title: "BetBattle | Battle with your friends through sports", meta: "BetBattle.gg is changing the way people interact with sporting events and wagers. Join in the fun now for free!", canonical: nil)
}
