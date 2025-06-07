//  WorkbenchFeature.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/07.

import ComposableArchitecture
import Foundation
import GraphFeature
import HashtagFeature
import PipelineFeature
import SwiftUI

@Reducer
public struct WorkbenchFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public var path = StackState<Path.State>()

    public init() {}
  }

  public enum Action: Equatable {
    case path(StackActionOf<Path>)
    case hashtagButtonTapped
    case pipelineButtonTapped
    case graphButtonTapped
  }

  @Reducer(state: .equatable, action: .equatable)
  public enum Path {
    case hashtag(HashtagManageTopFeature)
    case pipeline(PipelineManageTopFeature)
    case graph(GraphManageTopFeature)
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .hashtagButtonTapped:
        state.path.append(.hashtag(HashtagManageTopFeature.State()))
        return .none
      case .pipelineButtonTapped:
        state.path.append(.pipeline(PipelineManageTopFeature.State()))
        return .none
      case .graphButtonTapped:
        state.path.append(.graph(GraphManageTopFeature.State()))
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

public struct WorkbenchView: View {
  @Bindable
  var store: StoreOf<WorkbenchFeature>

  public init(store: StoreOf<WorkbenchFeature>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List {
        Button("ハッシュタグ管理") {
          store.send(.hashtagButtonTapped)
        }
        Button("パイプライン管理") {
          store.send(.pipelineButtonTapped)
        }
        Button("グラフ管理") {
          store.send(.graphButtonTapped)
        }
      }
    } destination: { store in
      switch store.case {
      case let .hashtag(store):
        HashtagManageTopView(store: store)
      case let .pipeline(store):
        PipelineManageTopView(store: store)
      case let .graph(store):
        GraphManageTopView(store: store)
      }
    }
    .navigationTitle("ワークベンチ画面")
  }
}

#Preview {
  NavigationStack {
    WorkbenchView(
      store: Store(
        initialState: WorkbenchFeature.State()
      ) {
        WorkbenchFeature()
      }
    )
  }
}
