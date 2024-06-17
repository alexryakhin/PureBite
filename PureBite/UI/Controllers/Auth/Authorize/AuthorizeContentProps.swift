import Foundation
import Combine
import EventSenderMacro
import EnumsMacros

@EventSender
public final class AuthorizeContentProps: ObservableObject, HaveInitialState {

    @PlainedEnum
    public enum Event {
        case finish
    }

    public static func initial() -> Self {
        Self()
    }
}

extension AuthorizeContentProps: Equatable {
    public static func == (lhs: AuthorizeContentProps, rhs: AuthorizeContentProps) -> Bool {
        false // don't compare
    }
}
