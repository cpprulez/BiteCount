//
//  Measurement+Helpers.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 16.04.25.
//

import Foundation

package extension Collection {
    func average<Unit: Dimension>() -> Element? where Element == Measurement<Unit> {
        first.map { dropFirst().reduce($0, +) / Double(count) }
    }
}
