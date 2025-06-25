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
    public var existingHashtags: [Hashtag] = []

    public var validationError: String? {
      let trimmedName = hashtag.name.trimmingCharacters(in: .whitespacesAndNewlines)

      if trimmedName.isEmpty {
        return "1文字以上入力してください"
      }

      if trimmedName.count > 10 {
        return "10文字以下で入力してください"
      }

      let isDuplicate = existingHashtags.contains { existingHashtag in
        existingHashtag.id != hashtag.id && existingHashtag.name == trimmedName
      }

      if isDuplicate {
        return "既に登録されている名前です"
      }

      return nil
    }

    public var isValid: Bool {
      validationError == nil
    }

    public init(
      hashtag: Hashtag,
      isNew: Bool,
      existingHashtags: [Hashtag]
    ) {
      self.hashtag = hashtag
      self.isNew = isNew
      self.existingHashtags = existingHashtags
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
        .none

      case .saveTapped:
        .run { [hashtag = state.hashtag] send in
          await send(.delegate(.hashtagSaved(hashtag)))
          @Dependency(\.dismiss)
          var dismiss
          await dismiss()
        }

      case .cancelTapped:
        .run { _ in
          @Dependency(\.dismiss)
          var dismiss
          await dismiss()
        }

      case .delegate:
        .none
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
      Section {
        TextField(
          "ハッシュタグ名",
          text: $store.hashtag.name
        )
      } header: {
        Text("ハッシュタグ名")
      } footer: {
        Text(store.validationError ?? "")
          .foregroundColor(.orange)
          .font(.caption)
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
        .disabled(!store.isValid)
      }
    }
  }
}

extension HashtagDataType {
  var displayName: String {
    switch self {
    case .number:
      "数値"
    }
  }
}

#Preview {
  NavigationStack {
    HashtagEditView(
      store: Store(
        initialState: HashtagEditFeature.State(
          hashtag: .mock,
          isNew: false,
          existingHashtags: []
        )
      ) {
        HashtagEditFeature()
      }
    )
  }
}
