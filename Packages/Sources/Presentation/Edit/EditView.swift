//
//  EditView.swift
//  Presentation
//
//  Created by Antoan Tateosyan on 15.04.25.
//

import SwiftUI
import Data

struct EditView: View {
    @Bindable var viewModel: ViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Form {
            if viewModel.showsDate {
                Section {
                    DatePicker("Day", selection: $viewModel.date, displayedComponents: .date)
                        .font(.largeTitle)
                } footer: {
                    if let footerMessage = viewModel.dateFooterMessage {
                        Text(footerMessage)
                            .foregroundStyle(.red)
                    }
                }
            }

            Section("Weight") {
                HStack {
                    TextField("Weight", value: $viewModel.weight, format: .number.precision(.fractionLength(0...1)))
                        .keyboardType(.decimalPad)
                        .font(.largeTitle)

                    Text(viewModel.unitText)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Intake") {
                TextField("Track with emoji", text: $viewModel.intake, axis: .vertical)
                    .font(.largeTitle)
            }
        }
        .toolbar {
            if viewModel.showsToolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: viewModel.didTapSave)
                        .disabled(!viewModel.isValid)
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Error",
            isPresented: $viewModel.isShowingErrorAlert,
            actions: { },
            message: { Text(viewModel.errorMessage) }
        )
        .onAppear(perform: viewModel.onAppear)
    }
}
