import Fluent

// MARK: Games
struct CreateGame: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("games")
            .unique(on: "spfID")
            .id()
            .field("spfID", .int)
            .field("league", .string)
            .field("awayTeam", .string)
            .field("homeTeam", .string)
            .field("awayMoneyline", .int)
            .field("homeMoneyline", .int)
            .field("awaySpread", .float)
            .field("awaySpreadOdds", .int)
            .field("homeSpread", .float)
            .field("homeSpreadOdds", .int)
            .field("total", .float)
            .field("totalOverOdds", .int)
            .field("totalUnderOdds", .int)
            .field("awayScore", .float)
            .field("homeScore", .float)
            .field("awayScoreByPeriod", .array(of: .int))
            .field("homeScoreByPeriod", .array(of: .int))
            .field("currentPeriod", .int)
            .field("periodTimeRemaining", .string)
            .field("status", .string)
            .field("location", .string)
            .field("date", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("games").delete()
    }
}

// MARK: Wager
struct CreateWager: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("wagers")
            .id()
            .field("user", .uuid)
            .foreignKey("user", references: "users", "id")
            .field("game", .uuid)
            .foreignKey("game", references: "games", "id")
            .field("contest", .uuid)
            .foreignKey("contest", references: "contests", "id")
            .field("type", .string)
            .field("amount", .float)
            .field("toWin", .float)
            .field("odds", .int)
            .field("value", .float)
            .field("total", .string)
            .field("grade", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("wagers").delete()
    }
}

// MARK: Contests
struct CreateContest: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("contests")
            .id()
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("contests").delete()
    }
}


// MARK: Teams
struct CreateTeam: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("teams")
            .unique(on: "name")
            .id()
            .field("league", .string)
            .field("name", .string, .required)
            .field("location", .string, .required)
            .field("nickname", .string, .required)
            .field("logo", .string)
            .field("primaryColor", .string)
            .field("secondaryColor", .string)
            .field("arena", .string)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("teams").delete()
    }
}

// MARK: Teams
struct CreateLeague: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("leagues")
            .id()
            .field("key", .string, .required)
            .field("active", .bool, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema("leagues").delete()
    }
}
