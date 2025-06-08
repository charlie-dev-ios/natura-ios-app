// HashtagManageTopFeature.swift
// Modules
//
// Created by kotaro-seki on 2025/06/07.

import CommonUI
import ComposableArchitecture
import Database
import Domain
import Foundation
import SharingGRDB
import SwiftUI

@Reducer
public struct HashtagManageTopFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action: Equatable {}

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { _, _ in .none }
  }
}

public struct HashtagManageTopView: View {
  let store: StoreOf<HashtagManageTopFeature>

  @FetchAll
  var hashtags: [Hashtag]

  public init(store: StoreOf<HashtagManageTopFeature>) {
    self.store = store
  }

  public var body: some View {
    contents
      .navigationTitle("Hashtags")
  }

  @ViewBuilder
  private var contents: some View {
    if hashtags.isEmpty {
      EmptyStateView(message: "ハッシュタグがありません")
    } else {
      List {
        ForEach(hashtags) { hashtag in
          Text(hashtag.name)
        }
      }
    }
  }
}

#Preview {
  let _ = prepareDependencies {
    $0.defaultDatabase = try! DatabaseSchema.appDatabase()
  }
  NavigationStack {
    HashtagManageTopView(
      store: Store(initialState: HashtagManageTopFeature.State()) {
        HashtagManageTopFeature()
      }
    )
  }
}
