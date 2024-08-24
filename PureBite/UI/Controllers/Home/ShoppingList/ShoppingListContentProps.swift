import Foundation
import Combine

public final class ShoppingListContentProps: ObservableObject, HaveInitialState {

    public static func initial() -> Self {
        Self()
    }
}

extension ShoppingListContentProps: Equatable {
    public static func == (lhs: ShoppingListContentProps, rhs: ShoppingListContentProps) -> Bool {
        false // don't compare
    }
}
