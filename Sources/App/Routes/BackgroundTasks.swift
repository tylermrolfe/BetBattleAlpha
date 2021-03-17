//
//  File.swift
//
//
//  Created by Tyler Rolfe on 1/4/21.
//

import Foundation
import Vapor
import Fluent
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func HelperTasks(_ app: Application) throws {
    
    app.get("board") { req -> EventLoopFuture<View> in
        return Game.query(on: req.db).filter(\.$status == "scheduled").sort(\.$date, .descending).all().flatMap { (games) -> EventLoopFuture<View> in
            return req.view.render("pages/board", ["data": GamesContext(meta: Pages.board, games: games)])
        }
    }
    
    app.get("gamesdb") { req -> EventLoopFuture<View> in
        return Game.query(on: req.db).filter(\.$status != "canceled").sort(\.$date, .descending).all().flatMap { (games) -> EventLoopFuture<View> in
            return req.view.render("games", ["gamesArr": games])
        }
    }
    
    app.get("time") { req -> String in
            let dateFormatter = DateFormatter()
            let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
            dateFormatter.locale = enUSPosixLocale
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateFormatter.calendar = Calendar(identifier: .gregorian)

            let iso8601String = dateFormatter.string(from: Date()) + "Z"
            return iso8601String
    }
}
