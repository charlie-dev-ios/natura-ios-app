// GraphManageTopFeature.swift
// Modules
//
// Created by kotaro-seki on 2025/06/07.

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct GraphManageTopFeature: Reducer {
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

public struct GraphManageTopView: View {
    let store: StoreOf<GraphManageTopFeature>

    public init(store: StoreOf<GraphManageTopFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("グラフ管理画面")
                .font(.title)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        GraphManageTopView(
            store: Store(initialState: GraphManageTopFeature.State()) {
                GraphManageTopFeature()
            }
        )
    }
}
