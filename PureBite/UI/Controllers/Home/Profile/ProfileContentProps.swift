import Foundation
import Combine
import EventSenderMacro
import EnumsMacros

@EventSender
public final class ProfileContentProps: ObservableObject, HaveInitialState {

    @PlainedEnum
    public enum Event {
        case finish
    }

    public static func initial() -> Self {
        Self()
    }
}

extension ProfileContentProps: Equatable {
    public static func == (lhs: ProfileContentProps, rhs: ProfileContentProps) -> Bool {
        false // don't compare
    }
}
