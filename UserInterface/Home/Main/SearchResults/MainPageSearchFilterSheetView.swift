//
//  MainPageSearchFilterSheetView.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 5/2/25.
//
import SwiftUI

struct MainPageSearchFilterSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var filters: RecipeSearchFilters
    var onApply: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Meal Type")) {
                    Picker("Type", selection: $filters.mealType) {
                        Text("Any").tag(nil as MealType?)
                        ForEach(MealType.allCases, id: \.self) {
                            Text($0.rawValue.capitalized)
                                .tag(Optional($0))
                        }
                    }
                }

                Section(header: Text("Sort By")) {
                    Picker("Sort", selection: $filters.sortBy) {
                        ForEach(SortingOption.filterAvailableOptions, id: \.self) {
                            Text($0.rawValue.capitalized)
                                .tag($0)
                        }
                    }
                }

                DisclosureGroup("Cuisine") {
                    MultipleSelectionView(
                        items: Cuisine.allCases,
                        selected: $filters.selectedCuisines
                    )
                }

                DisclosureGroup("Diet") {
                    MultipleSelectionView(
                        items: Diet.allCases,
                        selected: $filters.selectedDiets
                    )
                }

                DisclosureGroup("Nutrition") {
                    NutritionRangeView(title: "Calories", min: $filters.minCalories, max: $filters.maxCalories)
                    NutritionRangeView(title: "Protein (g)", min: $filters.minProtein, max: $filters.maxProtein)
                    NutritionRangeView(title: "Carbs (g)", min: $filters.minCarbs, max: $filters.maxCarbs)
                    NutritionRangeView(title: "Fat (g)", min: $filters.minFat, max: $filters.maxFat)
                }

                Section(header: Text("Ready in (minutes)")) {
                    Slider(value: $filters.maxReadyTime, in: 5...120, step: 5) {
                        Text("Max Ready Time")
                    }
                    Text("Max: \(Int(filters.maxReadyTime)) min")
                }
            }
            .navigationTitle("Filters")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .clipShape(Capsule())
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Reset") {
                        filters = RecipeSearchFilters.initial
                        onApply()
                        dismiss()
                    }
                    .disabled(!filters.isApplied)
                    .buttonStyle(.bordered)
                    .clipShape(Capsule())
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    onApply()
                    dismiss()
                } label: {
                    Text("Apply")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(12)
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .padding(vertical: 12, horizontal: 16)
                .disabled(!filters.isApplied)
            }
        }
    }
}
