// ___FILEHEADER___
​
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
public struct ___VARIABLE_featureName___: Reducer {
  @ObservableState
  public struct State: Equatable {}

  public enum Action {}

  public init() {}

  public var body: some ReducerOf<Self> {
    Reduce<State, Action> { _, action in
      switch action {}
    }
  }
}

public struct ___VARIABLE_viewName___: View {
  let store: StoreOf<___VARIABLE_featureName___>

  public init(store: StoreOf<___VARIABLE_featureName___>) {
    self.store = store
  }

  public var body: some View {
    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
  }
}

#Preview {
  ___VARIABLE_viewName___(
    store: Store(initialState: ___VARIABLE_featureName___.State()) {
      ___VARIABLE_featureName___()
    }
  )
}
