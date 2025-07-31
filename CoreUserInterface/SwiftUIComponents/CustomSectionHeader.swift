//
//  CustomSectionHeader.swift
//  RepsCount
//
//  Created by Aleksandr Riakhin on 3/19/25.
//

import SwiftUI

struct CustomSectionHeader: View {

    private let text: LocalizedStringKey

    init(text: String) {
        self.text = LocalizedStringKey(text)
    }

    init(text: LocalizedStringKey) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .textCase(.uppercase)
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
