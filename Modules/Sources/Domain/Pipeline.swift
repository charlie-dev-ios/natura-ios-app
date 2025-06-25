//  Pipeline.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/23.

import Foundation
import GRDB
import SharingGRDB

@Table
public struct Pipeline: Identifiable, Equatable, Hashable, Sendable {
  public let id: UUID
  public var name: String
  public var description: String
  @Column(as: Date.UnixTimeRepresentation.self)
  public var createdAt: Date
  @Column(as: Date.UnixTimeRepresentation.self)
  public var updatedAt: Date

  public init(
    id: UUID,
    name: String,
    description: String,
    createdAt: Date,
    updatedAt: Date
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}

// MARK: - GRDB Associations

extension Pipeline: TableRecord {
  /// PipelineHashtag への hasMany アソシエーション
  public static let pipelineHashtags = hasMany(PipelineHashtag.self)

  /// Hashtag への hasManyThrough アソシエーション（多対多関係）
  public static let hashtags = hasMany(
    Hashtag.self,
    through: pipelineHashtags,
    using: PipelineHashtag.hashtag
  )
}

extension Pipeline {
  public static let mock = Pipeline(
    id: UUID(),
    name: "Sample Pipeline",
    description: "This is a sample pipeline for testing purposes",
    createdAt: Date(),
    updatedAt: Date()
  )
}
