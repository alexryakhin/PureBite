import Foundation
import Combine
import EventSenderMacro
import EnumsMacros

@EventSender
public final class SavedContentProps: ObservableObject, HaveInitialState {

    @PlainedEnum
    public enum Event {
        case finish
    }

    public static func initial() -> Self {
        Self()
    }
}

extension SavedContentProps: Equatable {
    public static func == (lhs: SavedContentProps, rhs: SavedContentProps) -> Bool {
        false // don't compare
    }
}
