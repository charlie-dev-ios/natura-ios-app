//  HashtagEditFeature.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/08.
//

import ComposableArchitecture
import Domain
import Foundation
import SwiftUI

@Reducer
public struct HashtagEditFeature {
  @CasePathable
  public enum Delegate: Equatable {
    case hashtagSaved(Hashtag)
  }

  @ObservableState
  public struct State: Equatable {
    public var hashtag: Hashtag
    public var isNew: Bool
    public var errorMessage: String?
    public var invalidName: Bool {
      hashtag.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public init(
      hashtag: Hashtag,
      isNew: Bool
    ) {
      self.hashtag = hashtag
      self.isNew = isNew
      errorMessage = nil
    }
  }

  @CasePathable
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case saveTapped
    case cancelTapped
    case delegate(Delegate)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .saveTapped:
        guard !state.invalidName else {
          state.errorMessage = "ハッシュタグ名を入力してください"
          return .none
        }

        return .run { [hashtag = state.hashtag] send in
          await send(.delegate(.hashtagSaved(hashtag)))
          @Dependency(\.dismiss)
          var dismiss
          await dismiss()
        }

      case .cancelTapped:
        return .run { _ in
          @Dependency(\.dismiss)
          var dismiss
          await dismiss()
        }

      case .delegate:
        return .none
      }
    }
  }
}

public struct HashtagEditView: View {
  @Bindable
  var store: StoreOf<HashtagEditFeature>

  public init(store: StoreOf<HashtagEditFeature>) {
    self.store = store
  }

  public var body: some View {
    Form {
      Section(header: Text("ハッシュタグ名")) {
        TextField(
          "ハッシュタグ名",
          text: $store.hashtag.name
        )
      }

      Section(header: Text("データ形式")) {
        Picker(
          "データ形式",
          selection: $store.hashtag.dataType
        ) {
          ForEach(HashtagDataType.allCases, id: \.self) { type in
            Text(type.displayName).tag(type)
          }
        }
        .pickerStyle(.segmented)
      }

      if let error = store.errorMessage {
        Section {
          Text(error)
            .foregroundColor(.red)
            .font(.caption)
        }
      }
    }
    .navigationTitle(store.isNew ? "新規ハッシュタグ" : "ハッシュタグ編集")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button("キャンセル") {
          store.send(.cancelTapped)
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("保存") {
          store.send(.saveTapped)
        }
        .fontWeight(.semibold)
        .disabled(store.invalidName)
      }
    }
  }
}

extension HashtagDataType {
  var displayName: String {
    switch self {
    case .number:
      return "数値"
    }
  }
}

#Preview {
  NavigationStack {
    HashtagEditView(
      store: Store(
        initialState: HashtagEditFeature.State(
          hashtag: .mock,
          isNew: false
        )
      ) {
        HashtagEditFeature()
      }
    )
  }
}
