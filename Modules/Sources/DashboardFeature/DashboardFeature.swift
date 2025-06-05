//  DashboardFeature.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/05.

// import CommonUI
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct DashboardFeature: Reducer {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action: Equatable {}

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
    }
}

public struct DashboardView: View {
    let store: StoreOf<DashboardFeature>

    public init(store: StoreOf<DashboardFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("Dashboard")
    }
}

#Preview {
    NavigationStack {
        DashboardView(
            store: Store(
                initialState: DashboardFeature.State()
            ) {
                DashboardFeature()
            }
        )
    }
}
