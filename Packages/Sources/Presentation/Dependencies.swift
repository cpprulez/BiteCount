//
//  Dependencies.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import Data

public struct Dependencies {
    let repository: RepositoryProtocol

    public init(repository: RepositoryProtocol) {
        self.repository = repository
    }
}

public extension Dependencies {
    static func container() -> Self {
        .init(repository: CachedRepository())
    }
}
