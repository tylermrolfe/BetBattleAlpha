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
        .hourly().at(45)
    
    try app.queues.startInProcessJobs()
    try app.queues.startScheduledJobs()

    // register routes
    try TestRoutes(app)
    try BackgroundTasks(app)
}
