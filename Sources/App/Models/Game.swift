//
//  File.swift
//  
//
//  Created by Tyler Rolfe on 7/16/20.
//

import Foundation
import Fluent
import Vapor

final class Game: Model, Content {
    static let schema = "games"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "league")
    var league: String?
    
    @Field(key: "homeMoneyline")
    var homeMoneyline: Int?
    
    @Field(key: "awayMoneyline")
    var awayMoneyline: Int?
    
    @Field(key: "homeSpread")
    var homeSpread: Float?
    
    @Field(key: "awaySpread")
    var awaySpread: Float?
    
    @Field(key: "homeSpreadOdds")
    var homeSpreadOdds: Int?
    
    @Field(key: "awaySpreadOdds")
    var awaySpreadOdds: Int?
    
    @Field(key: "total")
    var total: Float?
    
    @Field(key: "totalOverOdds")
    var totalOverOdds: Int?
    
    @Field(key: "totalUnderOdds")
    var totalUnderOdds: Int?
    
    @Field(key: "homeScore")
    var homeScore: Int?
    
    @Field(key: "awayScoreByPeriod")
    var awayScoreByPeriod: [Int]?
    
    @Field(key: "homeScoreByPeriod")
    var homeScoreByPeriod: [Int]?
    
    @Field(key: "awayScore")
    var awayScore: Int?
    
    @Field(key: "currentPeriod")
    var currentPeriod: Int?
    
    @Field(key: "periodTimeRemaining")
    var periodTimeRemaining: String?
        
    @Field(key: "location")
    var location: String?
    
    @Field(key: "homeTeam")
    var homeTeam: String?
    
    @Field(key: "homeMascot")
    var homeMascot: String?
    
    @Field(key: "homeAbbreviation")
    var homeAbbreviation: String?
    
    @Field(key: "awayTeam")
    var awayTeam: String?
    
    @Field(key: "awayMascot")
    var awayMascot: String?
    
    @Field(key: "awayAbbreviation")
    var awayAbbreviation: String?
    
    @Field(key: "status")
    var status: String?
    
    /// Ex: 2020-12-20 16:05:00
    @Field(key: "date")
    var date: String?
    
    @Field(key: "spfID")
    var spfID: Int?
    
    func updateGame(_ game: SPFGame) {
        let odds = game.odds?[0]
        self.awayMoneyline = odds?.moneyline?.current?.awayOdds
        self.homeMoneyline = odds?.moneyline?.current?.homeOdds
        self.awaySpread = odds?.spread?.current?.away
        self.homeSpread = odds?.spread?.current?.home
        self.awaySpreadOdds = odds?.spread?.current?.awayOdds
        self.homeSpreadOdds = odds?.spread?.current?.homeOdds
        self.total = odds?.total?.current?.total
        self.totalOverOdds = odds?.total?.current?.overOdds
        self.totalUnderOdds = odds?.total?.current?.underOdds
        self.awayScore = game.scoreboard?.score?.away
        self.homeScore = game.scoreboard?.score?.home
        self.date = game.schedule?.date
        self.status = game.status?.rawValue
        self.currentPeriod = game.scoreboard?.currentPeriod
        self.periodTimeRemaining = game.scoreboard?.periodTimeRemaining
        self.location = game.venue?.name
        self.awayScoreByPeriod = game.scoreboard?.score?.awayPeriods
        self.homeScoreByPeriod = game.scoreboard?.score?.homePeriods
    }

    
    init() { }
    init(_ game: SPFGame) {
        self.spfID = game.gameID
        self.awayTeam = game.teams?.away?.team
        self.homeTeam = game.teams?.home?.team
        let odds = game.odds?[0]
        self.awayMoneyline = odds?.moneyline?.current?.awayOdds
        self.homeMoneyline = odds?.moneyline?.current?.homeOdds
        self.awaySpread = odds?.spread?.current?.away
        self.homeSpread = odds?.spread?.current?.home
        self.awaySpreadOdds = odds?.spread?.current?.awayOdds
        self.homeSpreadOdds = odds?.spread?.current?.homeOdds
        self.total = odds?.total?.current?.total
        self.totalOverOdds = odds?.total?.current?.overOdds
        self.totalUnderOdds = odds?.total?.current?.underOdds
        self.awayScore = game.scoreboard?.score?.away
        self.homeScore = game.scoreboard?.score?.home
        self.date = game.schedule?.date
        self.status = game.status?.rawValue
        self.currentPeriod = game.scoreboard?.currentPeriod
        self.periodTimeRemaining = game.scoreboard?.periodTimeRemaining
        self.location = game.venue?.name
        self.league = game.details?.league?.rawValue
        self.awayScoreByPeriod = game.scoreboard?.score?.awayPeriods
        self.homeScoreByPeriod = game.scoreboard?.score?.homePeriods
        self.homeAbbreviation = game.teams?.home?.abbreviation
        self.awayAbbreviation = game.teams?.away?.abbreviation
        self.homeMascot = game.teams?.home?.mascot
        self.awayMascot = game.teams?.away?.mascot
    }

}

final class Team: Model, Content {
    static let schema = "teams"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "league")
    var league: String?
    
    /// Boston Red Sox
    @Field(key: "name")
    var name: String?
    
    /// Boston
    @Field(key: "location")
    var location: String?
    
    /// Red Sox
    @Field(key: "nickname")
    var nickname: String?
    
    @Field(key: "logo")
    var logo: String?
    
    @Field(key: "primaryColor")
    var primaryColor: String?
    
    @Field(key: "secondaryColor")
    var secondaryColor: String?
    
    /// Fenway Park
    @Field(key: "arena")
    var arena: String?

        
    init() { }
}

extension String {
    func toFloat() -> Float {
        return Float(self) ?? 0.0
    }
}
