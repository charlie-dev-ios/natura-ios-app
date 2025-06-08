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
    @FetchAll
    var hashtags: [Hashtag]

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

  public init(store: StoreOf<HashtagManageTopFeature>) {
    self.store = store
  }

  public var body: some View {
    contents
      .navigationTitle("Hashtags")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("add") {
            @Dependency(\.defaultDatabase)
            var database
            let newItem = Hashtag.Draft(
              id: UUID(),
              name: "sample1",
              dataType: .number,
              createdAt: Date(),
              updatedAt: Date()
            )
            do {
              try database.write { db in
                try Hashtag.insert(newItem)
                  .execute(db)
              }
            } catch {
              print(error)
            }
          }
        }
      }
  }

  @ViewBuilder
  private var contents: some View {
    if store.state.hashtags.isEmpty {
      EmptyStateView(message: "ハッシュタグがありません")
    } else {
      List {
        ForEach(store.state.hashtags) { hashtag in
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
