//
//  Header.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import SwiftUI

package struct Header: View {
    package struct Model {
        let title: String
        let details: String

        package init(title: String, details: String) {
            self.title = title
            self.details = details
        }
    }

    private let model: Model

    package init(model: Model) {
        self.model = model
    }

    package var body: some View {
        HStack {
            Text(model.title)
                .font(.largeTitle.weight(.semibold))
                .fontDesign(.rounded)
                .foregroundStyle(.indigo.gradient)

            if !model.details.isEmpty {
                Spacer()
                Text(model.details)
                    .font(.footnote.weight(.semibold))
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(.capsule)
            }
        }
    }
}

#Preview {
    Header(model: .init(title: "January 2025", details: "65.1kg"))
}

