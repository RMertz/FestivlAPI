import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> String in
        return "Hello, world!"
    }

    let apiRoutes = app.grouped("api", "v1")

    //try app.register(collection: TodoController())
    try apiRoutes.register(collection: UserController())
    try apiRoutes.register(collection: FestivalController())
}
