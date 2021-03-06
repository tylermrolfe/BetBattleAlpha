//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 2/20/21.
//

import Foundation
import Vapor
import Fluent
import QueuesFluentDriver
import Queues
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct GamesJob: ScheduledJob {
    func run(context: QueueContext) -> EventLoopFuture<Void> {
        let url: String = Environment.get("URL")!
        networkRequestTo("\(url)") { (data, response, err) in
            do {
                if let gamesData = data {
                    let spf: SPF = try JSONDecoder().decode(SPF.self, from: gamesData)
                    guard let results = spf.results else { return }
                    for spfgame in results {
                        let newGame = Game.query(on: context.application.db).filter(\.$spfID == spfgame.gameID).first()
                        let _ = newGame.map { (queryGame) -> (String) in
                            if let existingGame = queryGame {
                                existingGame.updateGame(spfgame)
                                let _ = existingGame.update(on: context.application.db)
                            } else {
                                let game = Game(spfgame)
                                let _ = game.save(on: context.application.db)
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
        return context.eventLoop.future()
    }

    
    
//        func error(_ context: QueueContext, _ error: Error, _ payload: Game) -> EventLoopFuture<Void> {
//            // If you don't want to handle errors you can simply return a future. You can also omit this function entirely.
//            return context.eventLoop.future()
//        }
}

func networkRequestTo(_ link: String, completionHandler: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?)->Void) {
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    guard let URL = URL(string: link) else { return }
    
    var request = URLRequest(url: URL)
    
    let key = Environment.get("KEY")
    
    request.addValue(key ?? "", forHTTPHeaderField: "X-RapidAPI-Key")
    request.addValue("sportspage-feeds.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
    request.addValue("true", forHTTPHeaderField: "useQueryString")

    
    request.httpMethod = "GET"
    let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
        completionHandler(data, response, error)
    })
    
    task.resume()
    session.finishTasksAndInvalidate()
    
}

func runScheduledJobs(_ app: Application) {
    app.queues.schedule(GamesJob())
        .daily().at(12, 0)
    app.queues.schedule(GamesJob())
        .daily().at(13, 0)
    app.queues.schedule(GamesJob())
        .daily().at(14, 0)
    app.queues.schedule(GamesJob())
        .daily().at(15, 0)
    app.queues.schedule(GamesJob())
        .daily().at(16, 0)
    app.queues.schedule(GamesJob())
        .daily().at(17, 0)
    app.queues.schedule(GamesJob())
        .daily().at(18, 0)
    app.queues.schedule(GamesJob())
        .daily().at(18, 30)
    app.queues.schedule(GamesJob())
        .daily().at(19, 0)
    app.queues.schedule(GamesJob())
        .daily().at(19, 30)
    app.queues.schedule(GamesJob())
        .daily().at(20, 0)
    app.queues.schedule(GamesJob())
        .daily().at(20, 30)
    app.queues.schedule(GamesJob())
        .daily().at(21, 0)
    app.queues.schedule(GamesJob())
        .daily().at(21, 30)
    app.queues.schedule(GamesJob())
        .daily().at(22, 0)
    app.queues.schedule(GamesJob())
        .daily().at(22, 30)
    app.queues.schedule(GamesJob())
        .daily().at(23, 0)
    app.queues.schedule(GamesJob())
        .daily().at(1, 0)
    app.queues.schedule(GamesJob())
        .daily().at(2, 0)
    app.queues.schedule(GamesJob())
        .daily().at(3, 0)
    app.queues.schedule(GamesJob())
        .daily().at(4, 0)
}
