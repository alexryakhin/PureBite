import Foundation
import Combine
import EventSenderMacro
import EnumsMacros

@EventSender
public final class ShoppingListContentProps: ObservableObject, HaveInitialState {

    @PlainedEnum
    public enum Event {
        case finish
    }

    public static func initial() -> Self {
        Self()
    }
}

extension ShoppingListContentProps: Equatable {
    public static func == (lhs: ShoppingListContentProps, rhs: ShoppingListContentProps) -> Bool {
        false // don't compare
    }
}
