import Foundation
import Combine

public final class SavedContentProps: ObservableObject, HaveInitialState {

    @Published var groupedRecipes: [MealType: [Recipe]] = [:]

    public static func initial() -> Self {
        Self()
    }
}

extension SavedContentProps: Equatable {
    public static func == (lhs: SavedContentProps, rhs: SavedContentProps) -> Bool {
        false // don't compare
    }
}
