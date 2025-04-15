//
//  BiteCountApp.swift
//  BiteCount
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import SwiftUI
import Presentation

@main
struct BiteCountApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinator(dependencies: .container()).start()
        }
    }
}
