//  Pipeline.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/23.

import Foundation
import SharingGRDB
import StructuredQueries

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

extension Pipeline {
  public static let mock = Pipeline(
    id: UUID(),
    name: "Sample Pipeline",
    description: "This is a sample pipeline for testing purposes",
    createdAt: Date(),
    updatedAt: Date()
  )
}
