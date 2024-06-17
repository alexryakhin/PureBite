import Foundation
import EnumsMacros

public protocol AnyPageState { }

public struct PageState<
    ContentProps: Equatable,
    LoaderProps: Equatable,
    PlaceholderProps: Equatable,
    ErrorProps: Equatable
>: AnyPageState, Equatable {

    public typealias ContentProps = ContentProps
    public typealias LoaderProps = LoaderProps
    public typealias PlaceholderProps = PlaceholderProps
    public typealias ErrorProps = ErrorProps

    @PlainedEnum @CaseChecking
    public enum AdditionalState: Equatable {
        case loading(LoaderProps)
        case empty(PlaceholderProps)
        case error(ErrorProps)
    }

    public var contentProps: ContentProps
    public var additionalState: AdditionalState?

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

    public static func == (lhs: PageState<ContentProps, LoaderProps, PlaceholderProps, ErrorProps>, rhs: PageState<ContentProps, LoaderProps, PlaceholderProps, ErrorProps>) -> Bool {
        if lhs.additionalState != nil || rhs.additionalState != nil {
            return lhs.additionalState == rhs.additionalState
        } else {
            return lhs.contentProps == rhs.contentProps
        }
    }
}
