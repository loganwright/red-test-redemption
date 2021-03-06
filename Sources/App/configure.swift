
import FluentPostgreSQL 
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    /// Register providers first
    try services.register(FluentPostgreSQLProvider())
    

    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    

    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    
    /// Configure a PostgreSQL database
    services.register { c -> PostgreSQLDatabase in
        
        return try PostgreSQLDatabase(config: makeDatabaseConfig())
        
    }

    /// Register the configured PostgreSQL database to the database config.
    services.register { c -> DatabasesConfig in
        var databases = DatabasesConfig()
        
        try databases.add(database: c.make(PostgreSQLDatabase.self), as: .psql)
        
        return databases
    }

    /// Configure migrations
    services.register { c -> MigrationConfig in
        var migrations = MigrationConfig()
        
        migrations.add(model: Todo.self, database: .psql)
        
        return migrations
    }
    
}

func makeDatabaseConfig() -> PostgreSQLDatabaseConfig {
    if let url = Environment.get("DATABASE_URL") {
        return PostgreSQLDatabaseConfig(url: url)!
    }
    
    let hostname = Environment.get("DATABASE_HOSTNAME") ?? "localhost"
    let username = Environment.get("DATABASE_USER") ?? "vapor"
    let databaseName = Environment.get("DATABASE_DB") ?? "vapor"
    let password = Environment.get("DATABASE_PASSWORD") ?? "password"
    return PostgreSQLDatabaseConfig(
        hostname: hostname,
        username: username,
        database: databaseName,
        password: password
    )
}
