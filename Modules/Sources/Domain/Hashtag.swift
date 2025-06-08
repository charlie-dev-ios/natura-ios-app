//  Hashtag.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/07.

import Foundation
import SharingGRDB
import StructuredQueries

public enum HashtagDataType: String, CaseIterable, Equatable, Hashable, Sendable, QueryBindable {
  case number
}

@Table
public struct Hashtag: Identifiable, Equatable, Hashable, Sendable {
  public let id: UUID
  public var name: String
  public var dataType: HashtagDataType
  @Column(as: Date.UnixTimeRepresentation.self)
  public var createdAt: Date
  @Column(as: Date.UnixTimeRepresentation.self)
  public var updatedAt: Date

  public init(
    id: UUID,
    name: String,
    dataType: HashtagDataType,
    createdAt: Date,
    updatedAt: Date
  ) {
    self.id = id
    self.name = name
    self.dataType = dataType
    self.createdAt = createdAt
    self.updatedAt = updatedAt
  }
}
