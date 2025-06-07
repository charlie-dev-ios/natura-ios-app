// HashtagManageTopFeature.swift
// Modules
//
// Created by kotaro-seki on 2025/06/07.

import ComposableArchitecture
import Foundation
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

  public init(store: StoreOf<HashtagManageTopFeature>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      Text("ハッシュタグ管理画面")
        .font(.title)
        .padding()
      Spacer()
    }
  }
}

#Preview {
  NavigationStack {
    HashtagManageTopView(
      store: Store(initialState: HashtagManageTopFeature.State()) {
        HashtagManageTopFeature()
      }
    )
  }
}
