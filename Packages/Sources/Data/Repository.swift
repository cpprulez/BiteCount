//
//  Repository.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import Foundation

public enum RepositoryError: LocalizedError {
    case existingEntryForDay
    case duplicateEntry
    case negativeWeight

    public var errorDescription: String? {
        switch self {
        case .existingEntryForDay:
            "An entry for the given day already exists"
        case .duplicateEntry:
            "This entry already exists"
        case .negativeWeight:
            "Weight cannot be negative"
        }
    }
}

public protocol RepositoryProtocol {
    func fetchAllEntries() throws -> [Entry]
    func hasEntry(for day: Date) throws -> Bool
    func add(_ entry: Entry) throws
    func update(_ entry: Entry) throws
    func delete(_ entry: Entry) throws
}

public final class CachedRepository: RepositoryProtocol {
    private let storage: StorageServiceProtocol
    private let calendar: Calendar

    private var entries: [Entry]

    init(storage: StorageServiceProtocol, calendar: Calendar) {
        self.storage = storage
        self.calendar = calendar

        entries = (try? storage.load().map { $0.toDomain() }) ?? []
    }

    public convenience init() {
        self.init(storage: DefaultStorageService(), calendar: .current)
    }

    public func hasEntry(for day: Date) throws -> Bool {
        entries.contains { calendar.isDate($0.date, inSameDayAs: day) }
    }

    public func fetchAllEntries() throws -> [Entry] {
        entries
    }

    public func add(_ entry: Entry) throws {
        guard !(try hasEntry(for: entry.date)) else { throw RepositoryError.existingEntryForDay }
        guard index(of: entry) == nil else { throw RepositoryError.duplicateEntry }
        guard (entry.weight?.value ?? 0.0) >= 0.0 else { throw RepositoryError.negativeWeight }

        entries.append(entry)

        try save()
    }

    public func update(_ entry: Entry) throws {
        guard let index = index(of: entry) else { return }
        entries[index] = entry

        try save()
    }

    public func delete(_ entry: Entry) throws {
        guard let index = index(of: entry) else { return }
        entries.remove(at: index)

        try save()
    }

    private func save() throws {
        try storage.save(entries.map { $0.toDto() })
    }

    private func index(of entry: Entry) -> Int? {
        entries.firstIndex { $0.id == entry.id }
    }
}
