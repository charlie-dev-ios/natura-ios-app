//
//  NaturaApp.swift
//  Natura
//
//  Created by kotaro-seki on 2024/07/23.
//

import ComposableArchitecture
import RootFeature
import SwiftUI

@main
struct NaturaApp: App {
  static let store = Store(
    initialState: RootFeature.State()
  ) {
    RootFeature()
  }

  init() {
    prepareDependencies {
      $0.defaultDatabase = try! DatabaseSchema.appDatabase()
    }
  }

  var body: some Scene {
    WindowGroup {
      RootView(store: NaturaApp.store)
    }
  }
}
