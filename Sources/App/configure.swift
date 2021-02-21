import Fluent
import FluentPostgresDriver
import Vapor
import Leaf
import QueuesFluentDriver

// configures your application
public func configure(_ app: Application) throws {
    
    app.views.use(.leaf)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
            hostname: Environment.get("localhost") ?? "localhost",
            username: Environment.get("DBUSER") ?? "tylermrolfe",
            password: Environment.get("DBPASS") ?? "password",
            database: Environment.get("betbattle") ?? "betbattle"
    ), as: .psql)
//
    app.migrations.add(CreateGame())
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(CreateContest())
    app.migrations.add(CreateWager())
    app.migrations.add(JobModelMigrate())
    
    try app.autoMigrate().wait()
    
    app.queues.use(.fluent())
    
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
        .daily().at(24, 0)
    app.queues.schedule(GamesJob())
        .daily().at(1, 0)
    app.queues.schedule(GamesJob())
        .daily().at(2, 0)
    
    // Starts the queues off in the same thread.
    try app.queues.startInProcessJobs()
    try app.queues.startScheduledJobs()

    // register routes
    try TestRoutes(app)
    try BackgroundTasks(app)
}
