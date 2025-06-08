//
//  DatabaseSchema.swift
//  Natura
//
//  Created by kotaro-seki on 2025/06/07.
//

import Domain
import Foundation
import SharingGRDB

public enum DatabaseSchema {
  public static func appDatabase() throws -> any DatabaseWriter {
    @Dependency(\.context)
    var context

    var configuration = Configuration()
    configuration.foreignKeysEnabled = true

    #if DEBUG
      configuration.prepareDatabase { db in
        db.trace(options: .profile) {
          if context == .preview {
            print("\($0.expandedDescription)")
          } else {
            // TODO: use OSLog
//          logger.debug("\($0.expandedDescription)")
          }
        }
      }
    #endif

    let database: any DatabaseWriter
    if context == .live {
      let path = URL.documentsDirectory.appending(component: "db.sqlite").path()
      database = try DatabasePool(path: path, configuration: configuration)
    } else if context == .test {
      let path = URL.temporaryDirectory.appending(
        component: "\(UUID().uuidString)-db.sqlite"
      ).path()
      database = try DatabasePool(path: path, configuration: configuration)
    } else {
      database = try DatabaseQueue(configuration: configuration)
    }

    var migrator = DatabaseMigrator()
    #if DEBUG
      migrator.eraseDatabaseOnSchemaChange = true
    #endif

    migrator.registerMigration("Create Hashtags table") { db in
      try db.create(
        table: Hashtag.tableName,
        ifNotExists: true
      ) { t in
        t.column("id", .text).notNull().primaryKey(onConflict: .replace)
        t.column("name", .text).notNull()
        t.column("dataType", .text).notNull()
        t.column("createdAt", .datetime).notNull()
        t.column("updatedAt", .datetime).notNull()
      }
    }

    try migrator.migrate(database)

    #if DEBUG
      if context == .preview {
        do {
          try database.write { db in
            try db.seedSampleData()
          }
        } catch {
          print(error.localizedDescription)
        }
      }
    #endif

    return database
  }
}

#if DEBUG
  extension Database {
    func seedSampleData() throws {
      try seed {
        hashtag(name: "Reading")
        hashtag(name: "Training")
        hashtag(name: "Spent")
      }
    }

    private func hashtag(name: String) -> Hashtag {
      Hashtag(
        id: UUID(),
        name: name,
        dataType: .number,
        createdAt: Date(),
        updatedAt: Date()
      )
    }
  }
#endif
