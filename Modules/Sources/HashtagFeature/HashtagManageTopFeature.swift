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
    @Presents
    var hashtagEdit: HashtagEditFeature.State?
    var errorMessage: String?
    var hashtagToDelete: Hashtag?
    var showDeleteConfirmation = false

    public init() {}
  }

  public enum Action: Equatable {
    case hashtagTapped(Hashtag)
    case addButtonTapped
    case hashtagEdit(PresentationAction<HashtagEditFeature.Action>)
    case deleteHashtagSwipe(Hashtag)
    case deleteConfirmationPresented(Bool)
    case deleteConfirmed
    case deleteCancelled
  }

  public init() {}

  @Dependency(\.defaultDatabase)
  var database

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .hashtagTapped(hashtag):
        state.hashtagEdit = HashtagEditFeature.State(
          hashtag: hashtag,
          isNew: false,
          existingHashtags: state.hashtags
        )
        return .none

      case .addButtonTapped:
        state.hashtagEdit = HashtagEditFeature.State(
          hashtag: Hashtag(
            id: UUID(),
            name: "",
            dataType: .number,
            createdAt: Date(),
            updatedAt: Date()
          ),
          isNew: true,
          existingHashtags: state.hashtags
        )
        return .none

      case let .hashtagEdit(.presented(.delegate(.hashtagSaved(hashtag)))):
        do {
          try save(hashtag)
        } catch {
          state.errorMessage = error.localizedDescription
        }
        return .none

      case let .deleteHashtagSwipe(hashtag):
        state.hashtagToDelete = hashtag
        state.showDeleteConfirmation = true
        return .none

      case let .deleteConfirmationPresented(isPresented):
        state.showDeleteConfirmation = isPresented
        if !isPresented {
          state.hashtagToDelete = nil
        }
        return .none

      case .deleteConfirmed:
        guard let hashtag = state.hashtagToDelete else {
          return .none
        }
        state.showDeleteConfirmation = false
        state.hashtagToDelete = nil
        do {
          try delete(hashtag)
        } catch {
          state.errorMessage = error.localizedDescription
        }
        return .none

      case .deleteCancelled:
        state.showDeleteConfirmation = false
        state.hashtagToDelete = nil
        return .none

      case .hashtagEdit:
        return .none
      }
    }
    .ifLet(\.$hashtagEdit, action: \.hashtagEdit) {
      HashtagEditFeature()
    }
  }

  private func save(_ hashtag: Hashtag) throws {
    @Dependency(\.defaultDatabase)
    var database
    try database.write { db in
      try Hashtag.insert(hashtag)
        .execute(db)
    }
  }

  private func delete(_ hashtag: Hashtag) throws {
    @Dependency(\.defaultDatabase)
    var database
    try database.write { db in
      try Hashtag.delete(hashtag)
        .execute(db)
    }
  }
}

public struct HashtagManageTopView: View {
  @Bindable
  var store: StoreOf<HashtagManageTopFeature>

  public init(store: StoreOf<HashtagManageTopFeature>) {
    self.store = store
  }

  public var body: some View {
    contents
      .navigationTitle("Hashtags")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("add") {
            store.send(.addButtonTapped)
          }
        }
      }
      .sheet(item: $store.scope(state: \.hashtagEdit, action: \.hashtagEdit)) { hashtagEditStore in
        NavigationStack {
          HashtagEditView(store: hashtagEditStore)
        }
      }
      .alert(
        "ハッシュタグを削除",
        isPresented: $store.showDeleteConfirmation.sending(\.deleteConfirmationPresented)
      ) {
        Button("キャンセル", role: .cancel) {
          store.send(.deleteCancelled)
        }
        Button("削除", role: .destructive) {
          store.send(.deleteConfirmed)
        }
      } message: {
        if let hashtag = store.hashtagToDelete {
          Text("\(hashtag.name)を削除します。よろしいですか？")
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
          Button {
            store.send(.hashtagTapped(hashtag))
          } label: {
            HStack {
              Text(hashtag.name)
                .foregroundColor(.primary)
              Spacer()
              Text(hashtag.dataType.displayName)
                .font(.caption)
                .foregroundColor(.secondary)
            }
          }
          .buttonStyle(.plain)
          .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button("削除") {
              store.send(.deleteHashtagSwipe(hashtag))
            }
            .tint(.red)
          }
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
