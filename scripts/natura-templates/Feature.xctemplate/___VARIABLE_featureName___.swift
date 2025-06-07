// ___FILEHEADER___

import CommonUI
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct ___VARIABLE_featureName___: Reducer {
  @ObservableState
  struct State: Equatable {}

  enum Action {}

  var body: some ReducerOf<Self> {
    Reduce<State, Action> { _, action in
      switch action {}
    }
  }
}

struct ___VARIABLE_viewName___: View {
  let store: StoreOf<___VARIABLE_featureName___>

  var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  NavigationStack {
    ___VARIABLE_viewName___(
      store: Store(initialState: ___VARIABLE_featureName___.State()) {
        ___VARIABLE_featureName___()
      }
    )
  }
}
