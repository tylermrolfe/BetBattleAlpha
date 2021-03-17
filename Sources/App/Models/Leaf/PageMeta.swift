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
    let description: String
    let canonical: String?
    
    init(title: String, description: String, canonical: String?) {
        self.title = title
        self.description = description
        self.canonical = canonical
    }
}

struct Pages: Content {
    static let board = PageMeta(title: "Board | BetBattle", description: "Find and bet on games for all of your contests.", canonical: nil)
}
