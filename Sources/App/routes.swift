import Fluent
import FluentPostgresDriver
import Vapor
import SwiftSoup
import Jobs
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func routes(_ app: Application) throws {
    
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
        let intervalString: String = Environment.get("INTERVAL") ?? "999999999999"
        let interval: Double = Double(intervalString)!
        
        Jobs.add(interval: .seconds(interval)) {
            // Set Date
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-DD"
            let newDate = formatter.string(from: date)
            
            guard let url: String = Environment.get("URL") else { throw Abort(.badRequest) }
            networkRequestTo("\(url)?date=\(newDate)") { (data, response, err) in
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
  
    
    
    
    
    
//    app.get("wager") { req -> String in
//        let _id = UUID(uuidString: "10b5432b-5d70-4fdf-bfb8-b27e195bfeb7")
//        let _contest = UUID(uuidString: "70815841-e2cd-4d10-8c68-4637ef889343")
//        guard let id = _id else { return "" }
//        guard let contest = _contest else { return "" }
//        let game = Game.query(on: req.db).filter(\._$id == id).first()
//        game.map { (game) -> (String) in
//            let wager = Wager()
//            wager.amount = 10
//            wager.type = .total
//            wager.total = .over
//            wager.odds = 115
//            wager.$game.id = id
//            wager.$contest.id = contest
//            wager.toWin = wager.calculateWinnings()
//            wager.grade = .pending
//            wager.save(on: req.db)
//
//            return "Uhmmm"
//        }
//
//        return "Running Wager"
//    }
}
