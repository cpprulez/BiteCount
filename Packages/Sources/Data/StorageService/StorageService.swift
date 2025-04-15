//
//  StorageService.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 16.04.25.
//


import Foundation

protocol StorageServiceProtocol {
    func load() throws -> [EntryDto]
    func save(_ entries: [EntryDto]) throws
}

final class DefaultStorageService: StorageServiceProtocol {
    private static let url = URL.documentsDirectory.appending(path: "entries.json")

    func load() throws -> [EntryDto] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode([EntryDto].self, from: Data(contentsOf: Self.url))
    }

    func save(_ entries: [EntryDto]) throws {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601

        try encoder.encode(entries).write(to: Self.url, options: [.atomic, .completeFileProtection])
    }
}
