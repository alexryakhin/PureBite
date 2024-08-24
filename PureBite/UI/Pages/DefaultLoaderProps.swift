import Foundation

public struct DefaultLoaderProps: Equatable {
    public enum LoaderStyle {
        case spinner
    }

    public let loaderStyle: LoaderStyle

    public init(loaderStyle: LoaderStyle = .spinner) {
        self.loaderStyle = loaderStyle
    }
}
