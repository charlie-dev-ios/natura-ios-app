//  PipelineHashtag.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/25.

import Foundation
import GRDB
import SharingGRDB

@Table
public struct PipelineHashtag: Identifiable, Equatable, Hashable, Sendable {
  public let id: UUID
  public let pipelineId: UUID
  public let hashtagId: UUID
  @Column(as: Date.UnixTimeRepresentation.self)
  public var createdAt: Date

  public init(
    id: UUID,
    pipelineId: UUID,
    hashtagId: UUID,
    createdAt: Date
  ) {
    self.id = id
    self.pipelineId = pipelineId
    self.hashtagId = hashtagId
    self.createdAt = createdAt
  }
}

// MARK: - GRDB Associations

extension PipelineHashtag: TableRecord {
  /// Pipeline への belongsTo アソシエーション
  public static let pipeline = belongsTo(Pipeline.self)

  /// Hashtag への belongsTo アソシエーション
  public static let hashtag = belongsTo(Hashtag.self)
}

extension PipelineHashtag {
  public static let mock = PipelineHashtag(
    id: UUID(),
    pipelineId: UUID(),
    hashtagId: UUID(),
    createdAt: Date()
  )
}
