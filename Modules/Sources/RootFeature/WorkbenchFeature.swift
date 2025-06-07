//  WorkbenchFeature.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/07.

import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct WorkbenchFeature: Reducer {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, _ in .none }
    }
}

public struct WorkbenchView: View {
    let store: StoreOf<WorkbenchFeature>

    public init(store: StoreOf<WorkbenchFeature>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("ワークベンチ画面")
                .font(.title)
                .padding()
            Spacer()
        }
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
