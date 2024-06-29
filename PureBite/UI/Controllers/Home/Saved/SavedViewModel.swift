import Foundation
import Combine
import EnumsMacros
import EventSenderMacro

@EventSender
public final class SavedViewModel: DefaultPageViewModel<SavedContentProps> {

    @PlainedEnum
    public enum Event {
        case finish
    }

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(arg: Int) {
        super.init()

        setInitialState()
        setupBindings()
    }

    // MARK: - Public Methods

    public func retry() {

    }

    // MARK: - Private Methods

    private func setupBindings() {
    }

    private func setInitialState() {
        state = .init(contentProps: .initial())
    }
}
