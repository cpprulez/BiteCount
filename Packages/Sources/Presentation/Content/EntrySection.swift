//
//  EntrySection.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 16.04.25.
//

import Data
import Foundation

struct EntrySection: Identifiable, Equatable {
    let date: Date
    let entries: [Entry]

    var id: Date {
        date
    }
}
