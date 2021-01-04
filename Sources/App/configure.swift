import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
            hostname: Environment.get("localhost") ?? "localhost",
            username: Environment.get("DBUSER") ?? "tylermrolfe",
            password: Environment.get("DBPASS") ?? "password",
            database: Environment.get("betbattle") ?? "betbattle"
    ), as: .psql)
//
    app.migrations.add(CreateGame())
//    app.migrations.add(CreateTeam())
//    app.migrations.add(CreateLeague())
//    app.migrations.add(CreateContest())
//    app.migrations.add(CreateWager())
    
    try app.autoMigrate().wait()

    // register routes
    try routes(app)
}
