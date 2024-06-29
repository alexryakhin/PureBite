import Foundation
import Combine
import EventSenderMacro
import EnumsMacros

@EventSender
public final class SearchContentProps: ObservableObject, HaveInitialState {

    @PlainedEnum
    public enum Event {
        case finish
    }

    public static func initial() -> Self {
        Self()
    }
}

extension SearchContentProps: Equatable {
    public static func == (lhs: SearchContentProps, rhs: SearchContentProps) -> Bool {
        false // don't compare
    }
}
