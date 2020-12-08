import Fluent
import FluentSQLiteDriver
import FluentPostgresDriver
import Fluent
import Vapor
import Leaf

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease

    if true {
        setUpPostgres(app)
    } else {
        setUpSQLite(app)
    }

    addMigrations(app)
    setUpCors(app)

    // register routes
    try routes(app)
}

private func addMigrations(_ app: Application) {
    app.migrations.add(FestivalDTO.Migration())
    app.migrations.add(FestivalIterationDTO.Migration())
    app.migrations.add(StageDTO.Migration())
    app.migrations.add(ArtistDTO.Migration())
    app.migrations.add(ArtistSetDTO.Migration())
    app.migrations.add(StageFestivalIterationPivot.Migration())
    app.migrations.add(User.Migration())
    app.migrations.add(UserToken.Migration())
    app.migrations.add(UserRole.Migration())
    app.migrations.add(FestivalUserRole.Migration())
}

private func setUpCors(_ app: Application) {
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    let error = ErrorMiddleware.default(environment: app.environment)
    // Clear any existing middleware.
    app.middleware = .init()
    app.middleware.use(cors)
    app.middleware.use(error)
}

private func setUpSQLite(_ app: Application) {
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
}

private func setUpPostgres(_ app: Application) {
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? PostgresConfiguration.ianaPortNumber,
        username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
        password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
        database: Environment.get("DATABASE_NAME") ?? "vapor_database"
    ), as: .psql)
}
