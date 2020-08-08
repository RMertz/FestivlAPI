import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    addMigrations(app)

    // register routes
    try routes(app)
}

private func addMigrations(_ app: Application) {
    app.migrations.add(CreateFestival())
    app.migrations.add(CreateFestivalIteration())
    app.migrations.add(CreateArtist())
    app.migrations.add(CreateArtistSet())
    app.migrations.add(CreateStage())
    app.migrations.add(CreateStageFestivalIterationPivot())
}
