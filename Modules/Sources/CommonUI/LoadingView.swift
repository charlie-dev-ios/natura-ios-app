//  LoadingView.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/07.

import SwiftUI

public struct LoadingView: View {
  public init() {}

  public var body: some View {
    ZStack {
      Color.black.opacity(0.3)
        .ignoresSafeArea()
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .white))
        .scaleEffect(1.5)
    }
    .accessibilityIdentifier("LoadingView")
  }
}

#Preview {
  LoadingView()
}
