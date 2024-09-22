import Combine

public protocol AnyPageViewModel {
    associatedtype State: AnyPageState
}

public protocol HaveInitialState {
    static func initial() -> Self
}

public class PageViewModel<
    LoaderProps: Equatable,
    PlaceholderProps: Equatable,
    ErrorProps: Equatable
>: ObservableObject, AnyPageViewModel, Equatable, ErrorHandler where ErrorProps == ErrorProps {

    public typealias LoaderProps = LoaderProps
    public typealias PlaceholderProps = PlaceholderProps
    public typealias ErrorProps = ErrorProps

    public typealias State = PageState<
        LoaderProps,
        PlaceholderProps,
        ErrorProps
    >

    // MARK: - Properties

    @Published var state = State()

    weak var snacksDisplay: SnacksDisplay?

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    public init() { }

    func setState(_ newState: State) {
        state = newState
    }

    public static func == (lhs: PageViewModel<LoaderProps, PlaceholderProps, ErrorProps>, rhs: PageViewModel<LoaderProps, PlaceholderProps, ErrorProps>) -> Bool {
        lhs.state == rhs.state
    }

    func errorReceived(_ error: Error, contentPreserved: Bool) {
        guard let errorWithContext = error as? DefaultError else {
            warn("Unexpectedly receive `Error` which is not `DefaultError`")
            return
        }
        errorReceived(errorWithContext, contentPreserved: contentPreserved)
    }

    /// Override this function to implement custom error processing
    func errorReceived(
        _ error: DefaultError,
        contentPreserved: Bool,
        action: @escaping VoidHandler
    ) {
        defaultErrorHandler(
            error,
            contentPreserved: contentPreserved,
            action: action
        )
    }

    func defaultErrorHandler(
        _ error: DefaultError,
        contentPreserved: Bool,
        action: @escaping VoidHandler
    ) {
        let displayType = displayType(forError: error, contentPreserved: contentPreserved)

        switch displayType {
        case .page:
            defaultPageErrorHandler(error, action: action)
        case .snack:
            let message = error.errorDescription ?? error.localizedDescription
            if snacksDisplay == nil {
                fault("Failed to show Snack because page is invisible or `snacksDisplay` is nil at `\(type(of: self))`")
            }
            snacksDisplay?.showSnack(withConfig: SnackView.Config(message: message, style: .error))
        case .none:
            return
        }
    }

    func displayType(forError error: DefaultError, contentPreserved: Bool) -> ErrorDisplayType {
        contentPreserved ? .snack : .page
    }

    func defaultPageErrorHandler(_ error: DefaultError, action: @escaping VoidHandler) {
        assertionFailure()
    }

    func presentErrorPage(withProps errorProps: ErrorProps) {
        assertionFailure()
    }

    func loadingStarted() {
        assertionFailure()
    }
}
