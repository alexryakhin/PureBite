// swiftlint:disable:next final_class
public class DefaultPageViewModel<ContentProps: HaveInitialState & Equatable>: PageViewModel<ContentProps, DefaultLoaderProps, DefaultPlaceholderProps, DefaultErrorProps> {

    override func defaultPageErrorHandler(_ error: DefaultError, action: @escaping VoidHandler) {
        let props: DefaultErrorProps? = switch error.kind {
        case .timeout:
                .timeout(action: action)
        case .serverSendWrongData, .decodingError:
                .common(message: nil, action: action)
        case .server:
                .common(message: error.localizedDescription, action: action)
        case .network:
                .networkFailure(action: action)
        case .internal:
            nil
#if DEBUG
        case .debugError(let message):
                .common(message: message, action: action)
#endif
        case .fileDoesNotExist(let message):
                .common(message: message, action: action)
        case .fileReadError(let message):
                .common(message: message, action: action)
        }
        if let props {
            presentErrorPage(withProps: props)
        }
    }

    override func presentErrorPage(withProps errorProps: DefaultErrorProps) {
        state.additionalState = .error(errorProps)
    }

    override func loadingStarted() {
        state.additionalState = .loading(DefaultLoaderProps())
    }
}
