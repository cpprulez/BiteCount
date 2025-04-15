//
//  Calendar+Helpers.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 16.04.25.
//

import Foundation

package extension Calendar {
    func startOfMonth(for date: Date) -> Date? {
        dateInterval(of: .month, for: date)?.start
    }
}
