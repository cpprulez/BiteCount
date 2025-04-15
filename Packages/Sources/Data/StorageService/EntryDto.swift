//
//  EntryDto.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 16.04.25.
//

import Foundation

struct EntryDto: Codable {
    let id: UUID
    let date: Date
    let weight: Measurement<UnitMass>?
    let intake: String
}

extension EntryDto {
    func toDomain() -> Entry {
        .init(id: id, date: date, weight: weight, intake: Array(intake))
    }
}

extension Entry {
    func toDto() -> EntryDto {
        .init(id: id, date: date, weight: weight, intake: String(intake))
    }
}
