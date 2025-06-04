//
//  RootFeature.swift
//  Modules
//
//  Created by kotaro-seki on 2024/07/29.
//

// import CommonUI
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct RootFeature: Reducer {
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

public struct RootView: View {
    let store: StoreOf<RootFeature>

    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }

    public var body: some View {
        TabView {
            Text("Dashboard")
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.grid.2x2")
                }
            Text("Workbench")
                .tabItem {
                    Label("Workbench", systemImage: "hammer")
                }
            Text("Measurement")
                .tabItem {
                    Label("Measurement", systemImage: "waveform")
                }
        }
    }
}

#Preview {
    NavigationStack {
        RootView(
            store: Store(initialState: RootFeature.State()) {
                RootFeature()
            }
        )
    }
}
