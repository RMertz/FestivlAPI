import Fluent
import FluentSQLiteDriver
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease

    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    addMigrations(app)

    // register routes
    try routes(app)
}

private func addMigrations(_ app: Application) {
    app.migrations.add(FestivalDTO.Migration())
    app.migrations.add(FestivalIterationDTO.Migration())
    app.migrations.add(ArtistDTO.Migration())
    app.migrations.add(ArtistSetDTO.Migration())
    app.migrations.add(StageDTO.Migration())
    app.migrations.add(StageFestivalIterationPivot.Migration())
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(UserRole.Migration())
    app.migrations.add(FestivalUserRole.Migration())
}
