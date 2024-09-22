import Foundation

public protocol AnyPageState { }

public struct PageState<
    LoaderProps: Equatable,
    PlaceholderProps: Equatable,
    ErrorProps: Equatable
>: AnyPageState, Equatable {

    public typealias LoaderProps = LoaderProps
    public typealias PlaceholderProps = PlaceholderProps
    public typealias ErrorProps = ErrorProps

    public enum AdditionalState: Equatable {
        case loading(LoaderProps = DefaultLoaderProps())
        case empty(PlaceholderProps = DefaultPlaceholderProps())
        case error(ErrorProps)

        public var isLoading: Bool {
            if case .loading = self {
                return true
            }
            return false
        }

        public var isEmpty: Bool {
            if case .empty = self {
                return true
            }
            return false
        }

        public var isError: Bool {
            if case .error = self {
                return true
            }
            return false
        }
    }

    public var additionalState: AdditionalState?

    public var isContent: Bool { additionalState == nil }
    public var isLoading: Bool { additionalState?.isLoading ?? false }
    public var isEmpty: Bool { additionalState?.isEmpty ?? false }
    public var isError: Bool { additionalState?.isError ?? false }

    public var loaderProps: LoaderProps? {
        if case .loading(let loaderProps) = additionalState {
            return loaderProps
        }
        return nil
    }

    public var placeholderProps: PlaceholderProps? {
        if case .empty(let placeholderProps) = additionalState {
            return placeholderProps
        }
        return nil
    }

    public var errorProps: ErrorProps? {
        if case .error(let errorProps) = additionalState {
            return errorProps
        }
        return nil
    }

    public static func == (lhs: PageState<LoaderProps, PlaceholderProps, ErrorProps>, rhs: PageState<LoaderProps, PlaceholderProps, ErrorProps>) -> Bool {
        lhs.additionalState == rhs.additionalState
    }
}
