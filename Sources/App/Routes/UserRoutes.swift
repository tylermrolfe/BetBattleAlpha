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

func UserRoutes(_ app: Application) throws {
    
    app.get("hardget") { req -> String in
        let url: String = Environment.get("URL")!
        networkRequestTo("\(url)") { (data, response, err) in
            do {
                if let gamesData = data {
                    let spf: SPF = try JSONDecoder().decode(SPF.self, from: gamesData)
                    guard let results = spf.results else { return }
                    for spfgame in results {
                        let newGame = Game.query(on: req.db).filter(\.$spfID == spfgame.gameID).first()
                        let _ = newGame.map { (queryGame) -> (String) in
                            if let existingGame = queryGame {
                                existingGame.updateGame(spfgame)
                                let _ = existingGame.update(on: req.db)
                            } else {
                                let game = Game(spfgame)
                                let _ = game.save(on: req.db)
                            }
                            return "Game Saved/Updated"
                        }
                    }
                }
            }
            catch {
                print(error)
            }
        }
        return "Done"
    }
    
//    app.get("wager") { req -> EventLoopFuture<Wager> in
//        var wag = Wager()
//        wag.id = UUID()
//        wag.type = .moneyline
//        wag.amount = 10000
//        wag.toWin = 10900
//        wag.odds = 109
//        wag.value = 22
//        wag.total = WagerTotal.under
//        wag.grade = .pending
//        return Wager.create(wag)
//    }
    
    let tokenProtected = app.grouped(UserToken.authenticator())
    
    app.post("users") { req -> EventLoopFuture<User> in
        try User.Create.validate(req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(
            username: create.username,
            email: create.email,
            password: Bcrypt.hash(create.password),
            balance: 0
        )
        return user.save(on: req.db)
            .map { user }
    }
    
    let passwordProtected = app.grouped(User.authenticator())
    passwordProtected.post("login") { req -> EventLoopFuture<UserToken> in
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db)
            .map { token }
    }
    
    //MARK: Authorized Requests
    //TODO: Change to a post with a body

    
    tokenProtected.get("wager") { req -> String in
        do {
            let user = try req.auth.require(User.self)
            
            // Authorization Succeeds
            let _id = UUID(uuidString: "06ee8b76-b041-40fc-8d77-aceff32bc0ec")
            let _contest = UUID(uuidString: "b1e592d7-9742-496f-9c7c-8dbde0f02aa1")
            guard let id = _id else { return "" }
            guard let contest = _contest else { return "" }
            let game = Game.query(on: req.db).filter(\._$id == id).first()
            let _ = game.map { (game) -> (String) in
                let wager = Wager()
                wager.amount = 10
                wager.type = .total
                wager.total = .over
                wager.odds = 115
                wager.$user.id = user.id!
                wager.$game.id = id
                wager.$contest.id = contest
                wager.toWin = wager.calculateWinnings()
                wager.grade = .pending
                let _ = wager.save(on: req.db)
                
                return "Saved Wager"
            }
        }
        catch {
            return Abort(.unauthorized).reason
        }
        return "Running Wager"
    }
    
    
}
