//
//  ViewModel.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import Foundation
import Data
import DesignSystem
import Utils

extension ContentView {
    @Observable @MainActor
    final class ViewModel {
        private let repository: RepositoryProtocol
        private let grouping: EntryGrouping
        private let unit: UnitMass
        private let onAdd: () -> Void

        private var expandedSections = Set<Date>()

        init(
            repository: RepositoryProtocol,
            grouping: EntryGrouping = .byMonthDescending,
            unit: UnitMass,
            onAdd: @escaping () -> Void
        ) {
            self.repository = repository
            self.grouping = grouping
            self.unit = unit
            self.onAdd = onAdd
        }

        private(set) var sections: [EntrySection] = []

        @ObservationIgnored
        private var onAppearCalled = false

        private func load() {
            sections = grouping(entries: (try? repository.fetchAllEntries()) ?? [])
        }

        func rowModel(for entry: Entry) -> Row.Model {
            .init(
                title: entry.weight?.formatted(in: unit) ?? "-",
                subtitle: entry.date.formatted(.dateTime.day(.twoDigits).month(.abbreviated)),
                details: String(entry.intake),
                condensed: true
            )
        }

        func headerModel(for section: EntrySection) -> Header.Model {
            .init(
                title: section.date.formatted(.dateTime.month(.wide).year()),
                details: section.entries.compactMap(\.weight).average()?.formatted(in: unit) ?? ""
            )
        }

        func isExpanded(for section: EntrySection) -> Bool {
            expandedSections.contains(section.date)
        }

        func toggleSection(_ section: EntrySection, isExpanded: Bool) {
            if isExpanded {
                expandedSections.insert(section.date)
            } else {
                expandedSections.remove(section.date)
            }
        }

        func delete(at offsets: IndexSet, in section: EntrySection) {
            offsets.forEach {
                let entry = section.entries[$0]
                try? repository.delete(entry)
            }

            load()
        }

        func didTapAdd() {
            onAdd()
        }

        func onAppear() {
            load()

            if !onAppearCalled {
                onAppearCalled = true
                expandSection(for: .now)
            }
        }

        func entryAdded(_ entry: Entry) {
            load()
            expandSection(for: entry.date)
        }

        private func expandSection(for date: Date) {
            if let date = Calendar.current.startOfMonth(for: date) {
                expandedSections.insert(date)
            }
        }
    }
}

private extension Measurement<UnitMass> {
    func formatted(in unit: UnitMass) -> String {
        converted(to: unit)
            .formatted(
                .measurement(
                    width: .narrow,
                    usage: .asProvided,
                    numberFormatStyle: .number.precision(.fractionLength(0...1))
                )
            )
    }
}
