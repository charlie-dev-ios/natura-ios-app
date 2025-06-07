// PipelineManageTopFeature.swift
// Modules
//
// Created by kotaro-seki on 2025/06/07.

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct PipelineManageTopFeature: Reducer {
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

public struct PipelineManageTopView: View {
    let store: StoreOf<PipelineManageTopFeature>

    public init(store: StoreOf<PipelineManageTopFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("パイプライン管理画面")
                .font(.title)
                .padding()
            Spacer()
        }
    }
}

#Preview {
    NavigationStack {
        PipelineManageTopView(
            store: Store(initialState: PipelineManageTopFeature.State()) {
                PipelineManageTopFeature()
            }
        )
    }
}
