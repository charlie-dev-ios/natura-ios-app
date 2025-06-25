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

    migrator.registerMigration("Create Pipelines table") { db in
      try db.create(
        table: Pipeline.tableName,
        ifNotExists: true
      ) { t in
        t.column("id", .text).notNull().primaryKey(onConflict: .replace)
        t.column("name", .text).notNull()
        t.column("description", .text).notNull()
        t.column("createdAt", .datetime).notNull()
        t.column("updatedAt", .datetime).notNull()
      }
    }

    migrator.registerMigration("Create PipelineHashtags table") { db in
      try db.create(
        table: PipelineHashtag.tableName,
        ifNotExists: true
      ) { t in
        t.column("id", .text).notNull().primaryKey(onConflict: .replace)
        t.column("pipelineId", .text).notNull()
          .references(Pipeline.tableName, onDelete: .cascade)
        t.column("hashtagId", .text).notNull()
          .references(Hashtag.tableName, onDelete: .cascade)
        t.column("createdAt", .datetime).notNull()

        // 複合ユニーク制約（同じパイプライン-ハッシュタグの組み合わせは一意）
        t.uniqueKey(["pipelineId", "hashtagId"])
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
      let readingHashtag = hashtag(name: "Reading")
      let trainingHashtag = hashtag(name: "Training")
      let analyticsHashtag = hashtag(name: "Analytics")
      let backupHashtag = hashtag(name: "Backup")
      let mlModelHashtag = hashtag(name: "ML Model")

      let dataPipeline = pipeline(
        name: "Data Processing Pipeline",
        description: "Main data processing pipeline for analytics"
      )
      let backupPipeline = pipeline(
        name: "Backup Pipeline",
        description: "Daily backup and archival pipeline"
      )
      let mlPipeline = pipeline(
        name: "ML Training Pipeline",
        description: "Machine learning model training pipeline"
      )

      try seed {
        // ハッシュタグを作成
        readingHashtag
        trainingHashtag
        analyticsHashtag
        backupHashtag
        mlModelHashtag

        // パイプラインを作成
        dataPipeline
        backupPipeline
        mlPipeline

        // 多対多の関連付け
        // Data Processing Pipeline: Reading, Training, Analytics
        pipelineHashtag(pipelineId: dataPipeline.id, hashtagId: readingHashtag.id)
        pipelineHashtag(pipelineId: dataPipeline.id, hashtagId: trainingHashtag.id)
        pipelineHashtag(pipelineId: dataPipeline.id, hashtagId: analyticsHashtag.id)

        // Backup Pipeline: Backup
        pipelineHashtag(pipelineId: backupPipeline.id, hashtagId: backupHashtag.id)

        // ML Training Pipeline: Training, ML Model (Trainingは複数のパイプラインで共有)
        pipelineHashtag(pipelineId: mlPipeline.id, hashtagId: trainingHashtag.id)
        pipelineHashtag(pipelineId: mlPipeline.id, hashtagId: mlModelHashtag.id)
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

    private func pipeline(
      name: String,
      description: String
    ) -> Pipeline {
      Pipeline(
        id: UUID(),
        name: name,
        description: description,
        createdAt: Date(),
        updatedAt: Date()
      )
    }

    private func pipelineHashtag(
      pipelineId: UUID,
      hashtagId: UUID
    ) -> PipelineHashtag {
      PipelineHashtag(
        id: UUID(),
        pipelineId: pipelineId,
        hashtagId: hashtagId,
        createdAt: Date()
      )
    }
  }
#endif
