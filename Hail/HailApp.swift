//
//  HailApp.swift
//  Hail
//
//  Created by kotaro-seki on 2024/07/23.
//

import ComposableArchitecture
import RootFeature
import SwiftUI

@main
struct HailApp: App {
    static let store = Store(
        initialState: RootFeature.State()
    ) {
        RootFeature()
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: HailApp.store)
        }
    }
}
