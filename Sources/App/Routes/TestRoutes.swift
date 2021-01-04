import Fluent
import FluentPostgresDriver
import Vapor
import SwiftSoup
import Jobs
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func TestRoutes(_ app: Application) throws {
    
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
            password: Bcrypt.hash(create.password)
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
    
    app.get("hello") { req -> EventLoopFuture<View> in
        return req.view.render("hello", ["name": "Leaf"])
    }
    
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
