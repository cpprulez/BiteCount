//
//  Row.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import SwiftUI

package struct Row: View {
    package struct Model {
        let title: String
        let subtitle: String
        let details: String
        let condensed: Bool

        package init(title: String, subtitle: String, details: String, condensed: Bool = false) {
            self.title = title
            self.subtitle = subtitle
            self.details = details
            self.condensed = condensed
        }
    }

    private let model: Model

    package init(model: Model) {
        self.model = model
    }

    package var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.title.weight(.semibold))
                Text(model.subtitle)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(model.details)
                .font(.title)
                .tracking(model.condensed ? -8.0 : 0.0)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    Row(model: .init(title: "65kg", subtitle: "15 Apr", details: "🍔🥗🍰🥃🍻", condensed: true))
}
