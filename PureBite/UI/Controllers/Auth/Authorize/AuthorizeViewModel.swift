import Combine
import EnumsMacros
import EventSenderMacro
import Foundation

@EventSender
public final class AuthorizeViewModel: PageViewModel<
    AuthorizeContentProps,
    DefaultLoaderProps,
    DefaultPlaceholderProps,
    DefaultErrorProps
> {

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
        state.contentProps.on { [weak self] event in
            switch event {
            case .finish:
                self?.send(event: .finish)
            }
        }
    }

    private func setInitialState() {
        state = .init(contentProps: .initial())
    }
}
