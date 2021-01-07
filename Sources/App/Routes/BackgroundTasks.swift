//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 1/4/21.
//

import Foundation
import Vapor
import Fluent
import Jobs
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func BackgroundTasks(_ app: Application) throws {
    
    app.get("games") { req -> EventLoopFuture<View> in
        return Game.query(on: req.db).filter(\.$status != "canceled").sort(\.$date).all().flatMap { (games) -> EventLoopFuture<View> in
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
    
    app.get("run") { req -> String in
        let intervalString: String = Environment.get("INTERVAL") ?? "999999"
        let interval: Double = Double(intervalString)!
        
        Jobs.add(interval: .seconds(interval)) {
            // Set Date
            let dateFormatter = DateFormatter()
            let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
            dateFormatter.locale = enUSPosixLocale
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            dateFormatter.calendar = Calendar(identifier: .gregorian)

            let iso8601String = dateFormatter.string(from: Date())
            print(iso8601String)
            
            guard let url: String = Environment.get("URL") else { throw Abort(.badRequest) }
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
        }
        return "Running"
    }
}
