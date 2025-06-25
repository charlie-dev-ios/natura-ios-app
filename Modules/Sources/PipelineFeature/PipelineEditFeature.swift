//  PipelineEditFeature.swift
//  Modules
//
//  Created by kotaro-seki on 2025/06/23.
//

import ComposableArchitecture
import Domain
import Foundation
import SwiftUI

@Reducer
public struct PipelineEditFeature {
  @CasePathable
  public enum Delegate: Equatable {
    case pipelineSaved(Pipeline)
  }

  @ObservableState
  public struct State: Equatable {
    public var pipeline: Pipeline
    public var isNew: Bool
    public var existingPipelines: [Pipeline] = []

    public var validationError: String? {
      let trimmedName = pipeline.name.trimmingCharacters(in: .whitespacesAndNewlines)

      if trimmedName.isEmpty {
        return "1文字以上入力してください"
      }

      if trimmedName.count > 50 {
        return "50文字以下で入力してください"
      }

      let isDuplicate = existingPipelines.contains { existingPipeline in
        existingPipeline.id != pipeline.id && existingPipeline.name == trimmedName
      }

      if isDuplicate {
        return "既に登録されている名前です"
      }

      return nil
    }

    public var isValid: Bool {
      validationError == nil
    }

    public init(
      pipeline: Pipeline,
      isNew: Bool,
      existingPipelines: [Pipeline] = []
    ) {
      self.pipeline = pipeline
      self.isNew = isNew
      self.existingPipelines = existingPipelines
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case saveTapped
    case cancelTapped
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()
    Reduce { state, action in
      switch action {
      case .binding:
        return .none

      case .saveTapped:
        guard state.isValid else { return .none }

        var pipline = state.pipeline
        pipline.name = pipline.name.trimmingCharacters(in: .whitespacesAndNewlines)
        pipline.description = pipline.description.trimmingCharacters(in: .whitespacesAndNewlines)
        pipline.updatedAt = Date()
        if state.isNew {
          pipline.createdAt = Date()
        }
        return .run { [pipline] send in
          await send(.delegate(.pipelineSaved(pipline)))
          @Dependency(\.dismiss)
          var dismiss
          await dismiss()
        }

      case .cancelTapped:
        return .run { _ in
          @Dependency(\.dismiss)
          var dismiss
          await dismiss()
        }

      case .delegate:
        return .none
      }
    }
  }
}

public struct PipelineEditView: View {
  @Bindable
  var store: StoreOf<PipelineEditFeature>

  public init(store: StoreOf<PipelineEditFeature>) {
    self.store = store
  }

  public var body: some View {
    Form {
      Section {
        TextField(
          "パイプライン名",
          text: $store.pipeline.name
        )
      } header: {
        Text("パイプライン名")
      } footer: {
        Text(store.validationError ?? "")
          .foregroundColor(.orange)
          .font(.caption)
      }

      Section(header: Text("説明")) {
        TextField("説明（任意）", text: $store.pipeline.description, axis: .vertical)
          .textFieldStyle(.roundedBorder)
          .lineLimit(3 ... 6)
      }
    }
    .navigationTitle(store.isNew ? "新規パイプライン" : "パイプライン編集")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button("キャンセル") {
          store.send(.cancelTapped)
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("保存") {
          store.send(.saveTapped)
        }
        .fontWeight(.semibold)
        .disabled(!store.isValid)
      }
    }
  }
}

#Preview {
  NavigationStack {
    PipelineEditView(
      store: Store(
        initialState: PipelineEditFeature.State(
          pipeline: .mock,
          isNew: false,
          existingPipelines: []
        )
      ) {
        PipelineEditFeature()
      }
    )
  }
}
