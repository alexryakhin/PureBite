//
//  NutritionRangeView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/2/25.
//
import SwiftUI

struct NutritionRangeView: View {
    private let title: String
    @Binding private var min: Int?
    @Binding private var max: Int?

    init(
        title: String,
        min: Binding<Int?>,
        max: Binding<Int?>
    ) {
        self.title = title
        self._min = min
        self._max = max
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)

            HStack {
                TextField("Min", text: Binding(
                    get: { min.map(String.init) ?? "" },
                    set: { min = Int($0) }
                ))
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)

                Text("–")

                TextField("Max", text: Binding(
                    get: { max.map(String.init) ?? "" },
                    set: { max = Int($0) }
                ))
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
            }
        }
        .padding(.vertical, 4)
    }
}
