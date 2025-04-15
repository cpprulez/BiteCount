//
//  EntryGrouping.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 16.04.25.
//

import Foundation
import Data
import Utils

struct EntryGrouping {
    let group: ([Entry]) -> [EntrySection]

    func callAsFunction(entries: [Entry]) -> [EntrySection] {
        group(entries)
    }
}

extension EntryGrouping {
    static var byMonthDescending: Self {
        .init { entries in
            Dictionary(grouping: entries) { entry in
                Calendar.current.startOfMonth(for: entry.date) ?? entry.date
            }.map { startOfMonth, entries in
                EntrySection(
                    date: startOfMonth,
                    entries: entries.sorted(using: KeyPathComparator(\.date, order: .reverse))
                )
            }.sorted(using: KeyPathComparator(\.date, order: .reverse))
        }
    }
}
