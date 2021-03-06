import Fluent
import FluentPostgresDriver
import Vapor
import Leaf
import QueuesFluentDriver

// configures your application
public func configure(_ app: Application) throws {
    
    app.views.use(.leaf)
    app.leaf.cache.isEnabled = false
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.postgres(
            hostname: Environment.get("localhost") ?? "localhost",
            username: Environment.get("DBUSER") ?? "tylermrolfe",
            password: Environment.get("DBPASS") ?? "password",
            database: Environment.get("betbattle") ?? "betbattle"
    ), as: .psql)
    
    //MARK: Migrations
    app.migrations.add(CreateGame())
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(CreateContest())
    app.migrations.add(CreateWager())
    app.migrations.add(JobModelMigrate())
    app.migrations.add(AddGameFields())
    
    try app.autoMigrate().wait()
    
    app.queues.use(.fluent())
    
    
    //MARK: Scheduled Jobs
    runScheduledJobs(app)
    
    // Starts the queues off in the same thread.
    try app.queues.startInProcessJobs()
    try app.queues.startScheduledJobs()

    //MARK: Routes
    try TestRoutes(app)
    try HelperTasks(app)
}
