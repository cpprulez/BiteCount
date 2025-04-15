//
//  Entry.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import Foundation

public struct Entry: Identifiable, Hashable {
    public let id: UUID
    public var date: Date
    public var weight: Measurement<UnitMass>?
    public var intake: [Character]

    public init(
        id: UUID = .init(),
        date: Date = .now,
        weight: Measurement<UnitMass>? = nil,
        intake: [Character] = []
    ) {
        self.id = id
        self.date = date
        self.weight = weight
        self.intake = intake
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

#if DEBUG
extension Entry {
    static func makeSampleData() -> [Self] {
        var date = Date()
        let intake = "🥑🍳🍞🍗🍚🍣🍕🍎🥦🍇🥩🧀🍝🍤🍌🌮🍜🥕🍍🍫🍲🍓🍔🌯🍠☕🍵🥤🍺🍷🍶🍹🧃🍸🥛🍾🧉🍶"
        return (0..<30).map { _ in
            defer {
                date = Calendar.current.date(byAdding: .day, value: -.random(in: 1...10), to: date)!
            }

            return Entry(
                date: date,
                weight: Double.random(in: 0...1) <= 0.8
                    ? Measurement(value: .random(in: 40...120), unit: .kilograms)
                    : nil,
                intake: Array(intake.shuffled().prefix(.random(in: 0...15)))
            )
        }
    }
}
#endif
