//
//  ErrorRow.swift
//  DemoRacing
//
//  Created by Chamitha Wijesekera on 29/10/2024.
//

import SwiftUI

struct ErrorRow: View {

    let viewModel: ErrorViewModel
    let action: () -> Void

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "exclamationmark.circle.fill")
                    .accessibilityHidden(true)
                Text(viewModel.message)
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.caption)
            }
            .foregroundStyle(.primary)
            Button(action: action) {
                Text("Try again")
                    .font(.caption)
            }
            .buttonStyle(.bordered)
            .controlSize(.mini)
        }
        .padding(8)
        .frame(maxWidth: .infinity)
        .background(.gray6)
        .clipShape(.buttonBorder)
    }

}

#Preview {
    ErrorRow(viewModel: ErrorViewModel(error: ServiceError.invalidURL), action: {})
}
