//  Hashtag.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/07.

import Foundation

public enum HashtagDataType: String, Codable, CaseIterable, Equatable, Hashable {
  case number
}

public struct Hashtag: Identifiable, Codable, Equatable, Hashable {
  public let id: UUID
  public var name: String
  public var dataType: HashtagDataType
  public var createdAt: Date
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
