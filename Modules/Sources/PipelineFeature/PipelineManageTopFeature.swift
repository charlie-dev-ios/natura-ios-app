// PipelineManageTopFeature.swift
// Modules
//
// Created by kotaro-seki on 2025/06/23.

import CommonUI
import ComposableArchitecture
import Database
import Domain
import Foundation
import GRDB
import SharingGRDB
import SwiftUI

@Reducer
public struct PipelineManageTopFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    @FetchAll
    var pipelines: [Pipeline]
    @Presents
    var pipelineEdit: PipelineEditFeature.State?
    var errorMessage: String?
    var pipelineToDelete: Pipeline?
    var showDeleteConfirmation = false

    public init() {}
  }

  public enum Action: Equatable {
    case pipelineTapped(Pipeline)
    case addButtonTapped
    case pipelineEdit(PresentationAction<PipelineEditFeature.Action>)
    case deletePipelineSwipe(Pipeline)
    case deleteConfirmationPresented(Bool)
    case deleteConfirmed
    case deleteCancelled
  }

  public init() {}

  @Dependency(\.defaultDatabase)
  var database

  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .pipelineTapped(pipeline):
        state.pipelineEdit = PipelineEditFeature.State(
          pipeline: pipeline,
          isNew: false,
          existingPipelines: state.pipelines
        )
        return .none

      case .addButtonTapped:
        state.pipelineEdit = PipelineEditFeature.State(
          pipeline: Pipeline(
            id: UUID(),
            name: "",
            description: "",
            createdAt: Date(),
            updatedAt: Date()
          ),
          isNew: true,
          existingPipelines: state.pipelines
        )
        return .none

      case let .pipelineEdit(.presented(.delegate(.pipelineSaved(pipeline)))):
        do {
          try save(pipeline)
        } catch {
          state.errorMessage = error.localizedDescription
        }
        return .none

      case let .deletePipelineSwipe(pipeline):
        state.pipelineToDelete = pipeline
        state.showDeleteConfirmation = true
        return .none

      case let .deleteConfirmationPresented(isPresented):
        state.showDeleteConfirmation = isPresented
        if !isPresented {
          state.pipelineToDelete = nil
        }
        return .none

      case .deleteConfirmed:
        guard let pipeline = state.pipelineToDelete else {
          return .none
        }
        state.showDeleteConfirmation = false
        state.pipelineToDelete = nil
        do {
          try delete(pipeline)
        } catch {
          state.errorMessage = error.localizedDescription
        }
        return .none

      case .deleteCancelled:
        state.showDeleteConfirmation = false
        state.pipelineToDelete = nil
        return .none

      case .pipelineEdit:
        return .none
      }
    }
    .ifLet(\.$pipelineEdit, action: \.pipelineEdit) {
      PipelineEditFeature()
    }
  }

  private func save(_ pipeline: Pipeline) throws {
    @Dependency(\.defaultDatabase)
    var database
    try database.write { db in
      try Pipeline.insert(pipeline)
        .execute(db)
    }
  }

  private func delete(_ pipeline: Pipeline) throws {
    @Dependency(\.defaultDatabase)
    var database
    try database.write { db in
      try Pipeline.delete(pipeline)
        .execute(db)
    }
  }
}

public struct PipelineManageTopView: View {
  @Bindable
  var store: StoreOf<PipelineManageTopFeature>

  public init(store: StoreOf<PipelineManageTopFeature>) {
    self.store = store
  }

  public var body: some View {
    contents
      .navigationTitle("Pipelines")
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button("add") {
            store.send(.addButtonTapped)
          }
        }
      }
      .sheet(item: $store.scope(state: \.pipelineEdit, action: \.pipelineEdit)) { pipelineEditStore in
        NavigationStack {
          PipelineEditView(store: pipelineEditStore)
        }
      }
      .alert(
        "パイプラインを削除",
        isPresented: $store.showDeleteConfirmation.sending(\.deleteConfirmationPresented)
      ) {
        Button("キャンセル", role: .cancel) {
          store.send(.deleteCancelled)
        }
        Button("削除", role: .destructive) {
          store.send(.deleteConfirmed)
        }
      } message: {
        if let pipeline = store.pipelineToDelete {
          Text("\(pipeline.name)を削除します。よろしいですか？")
        }
      }
  }

  @ViewBuilder
  private var contents: some View {
    if store.state.pipelines.isEmpty {
      EmptyStateView(message: "パイプラインがありません")
    } else {
      List {
        ForEach(store.state.pipelines) { pipeline in
          PipelineRowView(
            pipeline: pipeline,
            onTap: { store.send(.pipelineTapped(pipeline)) },
            onDelete: { store.send(.deletePipelineSwipe(pipeline)) }
          )
        }
      }
    }
  }
}

struct PipelineRowView: View {
  let pipeline: Pipeline
  let onTap: () -> Void
  let onDelete: () -> Void

  var body: some View {
    Button(action: onTap) {
      VStack(alignment: .leading, spacing: 8) {
        Text(pipeline.name)
          .font(.headline)
          .foregroundColor(.primary)

        Text(pipeline.description)
          .font(.body)
          .foregroundColor(.secondary)
          .lineLimit(2)

        Text("更新日: \(pipeline.updatedAt, formatter: dateFormatter)")
          .font(.caption)
          .foregroundColor(.secondary)
      }
      .padding(.vertical, 4)
    }
    .buttonStyle(.plain)
    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
      Button("削除") {
        onDelete()
      }
      .tint(.red)
    }
  }
}

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .short
  formatter.timeStyle = .none
  return formatter
}()

#Preview {
  let _ = prepareDependencies {
    $0.defaultDatabase = try! DatabaseSchema.appDatabase()
  }
  NavigationStack {
    PipelineManageTopView(
      store: Store(initialState: PipelineManageTopFeature.State()) {
        PipelineManageTopFeature()
      }
    )
  }
}
