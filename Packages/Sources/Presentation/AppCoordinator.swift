// The Swift Programming Language
// https://docs.swift.org/swift-book

import Data
import SwiftUI

@Observable @MainActor
public final class AppCoordinator {
    private let dependencies: Dependencies

    // TODO: support multiple weight units
    private let unit: UnitMass = .kilograms

    enum Modal: Identifiable {
        case add((Entry) -> Void)

        var id: String {
            switch self {
            case .add:
                "addEntry"
            }
        }
    }

    var modal: Modal?

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    public func start() -> some View {
        weak var vm: ContentView.ViewModel?
        let viewModel = ContentView.ViewModel(
            repository: dependencies.repository,
            unit: unit,
            onAdd: { [self] in
                self.modal = .add { [weak self] entry in
                    vm?.entryAdded(entry)
                    self?.modal = nil
                }
            }
        )
        vm = viewModel

        return ContentView(viewModel: viewModel, coordinator: self)
            .tint(.cyan)
    }

    func makeAddView(onDidSave: @escaping (Entry) -> Void) -> some View {
        NavigationStack {
            EditView(viewModel: makeEditViewModel(mode: .add, onDidSave: onDidSave))
        }
    }

    func makeEditView(for entry: Entry) -> some View {
        EditView(viewModel: makeEditViewModel(mode: .edit(entry), onDidSave: { _ in }))
    }

    private func makeEditViewModel(
        mode: EditView.ViewModel.Mode,
        onDidSave: @escaping (Entry) -> Void
    ) -> EditView.ViewModel {
        .init(mode: mode, repository: dependencies.repository, unit: unit, onDidSave: onDidSave)
    }
}
