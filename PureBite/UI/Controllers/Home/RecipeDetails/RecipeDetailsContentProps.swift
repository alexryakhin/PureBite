import Foundation
import Combine
import EventSenderMacro
import EnumsMacros

@EventSender
public final class RecipeDetailsContentProps: ObservableObject, HaveInitialState {

    @PlainedEnum
    public enum Event {
        case finish
    }

    public static func initial() -> Self {
        Self()
    }
}

extension RecipeDetailsContentProps: Equatable {
    public static func == (lhs: RecipeDetailsContentProps, rhs: RecipeDetailsContentProps) -> Bool {
        false // don't compare
    }
}
