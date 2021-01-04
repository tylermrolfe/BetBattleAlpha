// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - SPF
public struct SPF: Codable {
    public let status: Int?
    public let time: String?
    public let games: Int?
    public let skip: Int?
    public let results: [SPFGame]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case time = "time"
        case games = "games"
        case skip = "skip"
        case results = "results"
    }

    public init(status: Int?, time: String?, games: Int?, skip: Int?, results: [SPFGame]?) {
        self.status = status
        self.time = time
        self.games = games
        self.skip = skip
        self.results = results
    }
}

// MARK: - Result
public struct SPFGame: Codable {
    public let schedule: Schedule?
    public let summary: String?
    public let details: Details?
    public let status: Status?
    public let teams: Teams?
    public let lastUpdated: String?
    public let gameID: Int?
    public let venue: Venue?
    public let odds: [Odd]?
    public let scoreboard: Scoreboard?

    enum CodingKeys: String, CodingKey {
        case schedule = "schedule"
        case summary = "summary"
        case details = "details"
        case status = "status"
        case teams = "teams"
        case lastUpdated = "lastUpdated"
        case gameID = "gameId"
        case venue = "venue"
        case odds = "odds"
        case scoreboard = "scoreboard"
    }

    public init(schedule: Schedule?, summary: String?, details: Details?, status: Status?, teams: Teams?, lastUpdated: String?, gameID: Int?, venue: Venue?, odds: [Odd]?, scoreboard: Scoreboard?) {
        self.schedule = schedule
        self.summary = summary
        self.details = details
        self.status = status
        self.teams = teams
        self.lastUpdated = lastUpdated
        self.gameID = gameID
        self.venue = venue
        self.odds = odds
        self.scoreboard = scoreboard
    }
}

// MARK: - Details
public struct Details: Codable {
    public let league: SPFLeague?
    public let seasonType: SeasonType?
    public let season: Int?
    public let conferenceGame: Bool?
    public let divisionGame: Bool?

    enum CodingKeys: String, CodingKey {
        case league = "league"
        case seasonType = "seasonType"
        case season = "season"
        case conferenceGame = "conferenceGame"
        case divisionGame = "divisionGame"
    }

    public init(league: SPFLeague?, seasonType: SeasonType?, season: Int?, conferenceGame: Bool?, divisionGame: Bool?) {
        self.league = league
        self.seasonType = seasonType
        self.season = season
        self.conferenceGame = conferenceGame
        self.divisionGame = divisionGame
    }
}

public enum SPFLeague: String, Codable {
    case nba = "NBA"
    case ncaab = "NCAAB"
    case ncaaf = "NCAAF"
    case nfl = "NFL"
    case mlb = "MLB"
    case nhl = "NHL"
}

public enum SeasonType: String, Codable {
    case regular = "regular"
    case postseason = "postseason"
}

// MARK: - Odd
public struct Odd: Codable {
    public let spread: Spread?
    public let moneyline: Moneyline?
    public let total: Total?
    public let openDate: String?
    public let lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case spread = "spread"
        case moneyline = "moneyline"
        case total = "total"
        case openDate = "openDate"
        case lastUpdated = "lastUpdated"
    }

    public init(spread: Spread?, moneyline: Moneyline?, total: Total?, openDate: String?, lastUpdated: String?) {
        self.spread = spread
        self.moneyline = moneyline
        self.total = total
        self.openDate = openDate
        self.lastUpdated = lastUpdated
    }
}

// MARK: - Moneyline
public struct Moneyline: Codable {
    public let moneylineOpen: MoneylineDetails?
    public let current: MoneylineDetails?

    enum CodingKeys: String, CodingKey {
        case moneylineOpen = "open"
        case current = "current"
    }

    public init(moneylineOpen: MoneylineDetails?, current: MoneylineDetails?) {
        self.moneylineOpen = moneylineOpen
        self.current = current
    }
}

// MARK: - MoneylineCurrent
public struct MoneylineDetails: Codable {
    public let awayOdds: Int?
    public let homeOdds: Int?

    enum CodingKeys: String, CodingKey {
        case awayOdds = "awayOdds"
        case homeOdds = "homeOdds"
    }

    public init(awayOdds: Int?, homeOdds: Int?) {
        self.awayOdds = awayOdds
        self.homeOdds = homeOdds
    }
}

// MARK: - Spread
public struct Spread: Codable {
    public let spreadOpen: SpreadDetails?
    public let current: SpreadDetails?

    enum CodingKeys: String, CodingKey {
        case spreadOpen = "open"
        case current = "current"
    }

    public init(spreadOpen: SpreadDetails?, current: SpreadDetails?) {
        self.spreadOpen = spreadOpen
        self.current = current
    }
}

// MARK: - SpreadCurrent
public struct SpreadDetails: Codable {
    public let away: Float?
    public let home: Float?
    public let awayOdds: Int?
    public let homeOdds: Int?

    enum CodingKeys: String, CodingKey {
        case away = "away"
        case home = "home"
        case awayOdds = "awayOdds"
        case homeOdds = "homeOdds"
    }

    public init(away: Float?, home: Float?, awayOdds: Int?, homeOdds: Int?) {
        self.away = away
        self.home = home
        self.awayOdds = awayOdds
        self.homeOdds = homeOdds
    }
}

// MARK: - Total
public struct Total: Codable {
    public let totalOpen: TotalCurrent?
    public let current: TotalCurrent?

    enum CodingKeys: String, CodingKey {
        case totalOpen = "open"
        case current = "current"
    }

    public init(totalOpen: TotalCurrent?, current: TotalCurrent?) {
        self.totalOpen = totalOpen
        self.current = current
    }
}

// MARK: - TotalCurrent
public struct TotalCurrent: Codable {
    public let total: Float?
    public let overOdds: Int?
    public let underOdds: Int?

    enum CodingKeys: String, CodingKey {
        case total = "total"
        case overOdds = "overOdds"
        case underOdds = "underOdds"
    }

    public init(total: Float?, overOdds: Int?, underOdds: Int?) {
        self.total = total
        self.overOdds = overOdds
        self.underOdds = underOdds
    }
}

// MARK: - Schedule
public struct Schedule: Codable {
    public let date: String?
    public let tbaTime: Bool?

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case tbaTime = "tbaTime"
    }

    public init(date: String?, tbaTime: Bool?) {
        self.date = date
        self.tbaTime = tbaTime
    }
}

// MARK: - Scoreboard
public struct Scoreboard: Codable {
    public let score: Score?
    public let currentPeriod: Int?
    public let periodTimeRemaining: String?

    enum CodingKeys: String, CodingKey {
        case score = "score"
        case currentPeriod = "currentPeriod"
        case periodTimeRemaining = "periodTimeRemaining"
    }

    public init(score: Score?, currentPeriod: Int?, periodTimeRemaining: String?) {
        self.score = score
        self.currentPeriod = currentPeriod
        self.periodTimeRemaining = periodTimeRemaining
    }
}

// MARK: - Score
public struct Score: Codable {
    public let away: Int?
    public let home: Int?
    public let awayPeriods: [Int]?
    public let homePeriods: [Int]?

    enum CodingKeys: String, CodingKey {
        case away = "away"
        case home = "home"
        case awayPeriods = "awayPeriods"
        case homePeriods = "homePeriods"
    }

    public init(away: Int?, home: Int?, awayPeriods: [Int]?, homePeriods: [Int]?) {
        self.away = away
        self.home = home
        self.awayPeriods = awayPeriods
        self.homePeriods = homePeriods
    }
}

public enum Status: String, Codable {
    case canceled = "canceled"
    case scheduled = "scheduled"
    case statusFinal = "final"
    case live = "in progress"
    case delayed = "delayed"
}

// MARK: - Teams
public struct Teams: Codable {
    public let away: SPFTeam?
    public let home: SPFTeam?

    enum CodingKeys: String, CodingKey {
        case away = "away"
        case home = "home"
    }

    public init(away: SPFTeam?, home: SPFTeam?) {
        self.away = away
        self.home = home
    }
}

// MARK: - Team
public struct SPFTeam: Codable {
    public let team: String?
    public let location: String?
    public let mascot: String?
    public let abbreviation: String?
    public let conference: String?
    public let division: String?

    enum CodingKeys: String, CodingKey {
        case team = "team"
        case location = "location"
        case mascot = "mascot"
        case abbreviation = "abbreviation"
        case conference = "conference"
        case division = "division"
    }

    public init(team: String?, location: String?, mascot: String?, abbreviation: String?, conference: String?, division: String?) {
        self.team = team
        self.location = location
        self.mascot = mascot
        self.abbreviation = abbreviation
        self.conference = conference
        self.division = division
    }
}

// MARK: - Venue
public struct Venue: Codable {
    public let name: String?
    public let city: String?
    public let state: String?
    public let neutralSite: Bool?

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case city = "city"
        case state = "state"
        case neutralSite = "neutralSite"
    }

    public init(name: String?, city: String?, state: String?, neutralSite: Bool?) {
        self.name = name
        self.city = city
        self.state = state
        self.neutralSite = neutralSite
    }
}
