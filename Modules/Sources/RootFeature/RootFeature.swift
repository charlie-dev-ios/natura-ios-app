//
//  RootFeature.swift
//  Modules
//
//  Created by kotaro-seki on 2024/07/29.
//

import CommonUI
import ComposableArchitecture
import DashboardFeature
import Foundation
import SwiftUI

@Reducer
public struct RootFeature: Reducer {
    @ObservableState
    public struct State: Equatable {
        var dashboard = DashboardFeature.State()
        var workbench = WorkbenchFeature.State()

        public init() {}
    }

    public enum Action: Equatable {
        case dashboard(DashboardFeature.Action)
        case workbench(WorkbenchFeature.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(
            state: \.dashboard,
            action: \.dashboard
        ) {
            DashboardFeature()
        }
        Scope(
            state: \.workbench,
            action: \.workbench
        ) {
            WorkbenchFeature()
        }
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
            DashboardView(
                store: store.scope(
                    state: \.dashboard,
                    action: \.dashboard
                )
            )
            .tabItem {
                Label(
                    "Dashboard",
                    systemImage: "rectangle.grid.2x2"
                )
            }

            WorkbenchView(
                store: store.scope(
                    state: \.workbench,
                    action: \.workbench
                )
            )
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
