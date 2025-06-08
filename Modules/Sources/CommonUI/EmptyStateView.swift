// EmptyStateView.swift
// CommonUI
//
// ハッシュタグなどのリストが空の場合に表示する共通ビュー

import SwiftUI

public struct EmptyStateView: View {
  let message: String

  public init(message: String) {
    self.message = message
  }

  public var body: some View {
    VStack {
      Spacer()
      Text(message)
        .font(.body)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding()
      Spacer()
    }
    .accessibilityIdentifier("emptyStateView")
  }
}

#Preview {
  EmptyStateView(message: "ハッシュタグがありません")
}
