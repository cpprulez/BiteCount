//
//  ContentView.swift
//  BiteCount
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import SwiftUI
import Data
import DesignSystem

struct ContentView: View {
    let viewModel: ViewModel
    @Bindable var coordinator: AppCoordinator

    var body: some View {
        NavigationStack {
            List(viewModel.sections) { section in
                DisclosureGroup(isExpanded: isExpanded(for: section)) {
                    ForEach(section.entries) { entry in
                        NavigationLink(value: entry) {
                            Row(model: viewModel.rowModel(for: entry))
                        }
                    }
                    .onDelete { offsets in
                        viewModel.delete(at: offsets, in: section)
                    }
                } label: {
                    Header(model: viewModel.headerModel(for: section))
                }
            }
            .animation(.default, value: viewModel.sections)
            .listStyle(.plain)
            .overlay {
                if viewModel.sections.isEmpty {
                    emptyContents
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add", systemImage: "plus", action: handleAdd)
                }
            }
            .sheet(item: $coordinator.modal) { modal in
                switch modal {
                case .add(let onDidSave):
                    coordinator.makeAddView(onDidSave: onDidSave)
                }
            }
            .navigationTitle("Bite Count")
            .navigationDestination(for: Entry.self, destination: coordinator.makeEditView)
            .onAppear(perform: viewModel.onAppear)
        }
    }

    private func isExpanded(for section: EntrySection) -> Binding<Bool> {
        .init(
            get: { viewModel.isExpanded(for: section) },
            set: { viewModel.toggleSection(section, isExpanded: $0) }
        )
    }

    private func handleAdd() {
        viewModel.didTapAdd()
    }

    private var emptyContents: some View {
        ContentUnavailableView {
            Text("No entries found")
        } description: {
            Text("tap the plus button to add your first entry")
        } actions: {
            Button("Add", systemImage: "plus", action: handleAdd)
                .buttonStyle(.borderedProminent)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    let repository = CachedRepository()
    ContentView(
        viewModel: .init(repository: repository, unit: .kilograms, onAdd: {}),
        coordinator: .init(dependencies: .init(repository: repository))
    )
}
