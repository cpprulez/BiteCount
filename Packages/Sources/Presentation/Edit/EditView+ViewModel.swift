//
//  ViewModel.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import Foundation
import Data

extension EditView {
    @Observable @MainActor
    final class ViewModel {
        enum Mode {
            case add
            case edit(Entry)
        }

        private let mode: Mode
        private let repository: RepositoryProtocol
        private let unit: UnitMass
        private let onDidSave: (Entry) -> Void

        private(set) var dateFooterMessage: String?
        private(set) var errorMessage = ""
        var isShowingErrorAlert = false

        private var entry: Entry {
            didSet {
                guard entry != oldValue else { return }
                if shouldAutosave {
                    attemptSave()
                }
            }
        }

        init(
            mode: Mode,
            repository: RepositoryProtocol,
            unit: UnitMass,
            onDidSave: @escaping (Entry) -> Void
        ) {
            self.mode = mode
            self.repository = repository
            self.unit = unit
            self.onDidSave = onDidSave

            switch mode {
            case .add:
                entry = .init()
            case .edit(let entry):
                self.entry = entry
            }
        }

        var unitText: String {
            unit.symbol
        }

        var date: Date {
            get { entry.date }
            set {
                entry.date = newValue

                checkDate()
            }
        }

        var weight: Double? {
            get { entry.weight?.converted(to: unit).value }
            set {
                if let newValue, newValue >= 0.0 {
                    entry.weight = .init(value: newValue, unit: unit)
                } else {
                    entry.weight = nil
                }
            }
        }

        var intake: String {
            get { String(entry.intake) }
            set { entry.intake = Array(newValue) }
        }

        var isValid: Bool {
            dateFooterMessage == nil
        }

        var showsDate: Bool {
            switch mode {
            case .add: return true
            case .edit: return false
            }
        }

        var showsToolbar: Bool {
            switch mode {
            case .add: return true
            case .edit: return false
            }
        }

        func didTapSave() {
            attemptSave()
        }

        func onAppear() {
            checkDate()
        }

        var navigationTitle: String {
            switch mode {
            case .add:
                "Add Entry"
            case .edit:
                entry.date.formatted(date: .numeric, time: .omitted)
            }
        }

        private var shouldAutosave: Bool {
            switch mode {
            case .add: false
            case .edit: true
            }
        }

        private func attemptSave() {
            do {
                switch mode {
                case .add:
                    try repository.add(entry)
                case .edit:
                    try repository.update(entry)
                }
                errorMessage = ""
                onDidSave(entry)
            } catch {
                errorMessage = error.localizedDescription
                isShowingErrorAlert = true
            }
        }

        private func checkDate() {
            switch mode {
            case .add:
                if (try? repository.hasEntry(for: date)) == true {
                    dateFooterMessage = "Entry for this day already exists"
                } else {
                    dateFooterMessage = nil
                }
            case .edit:
                break
            }
        }
    }
}
