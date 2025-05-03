//
//  DefaultPageViewModel.swift
//  Suint One
//
//  Created by Aleksandr Riakhin on 9/30/24.
//
import Foundation
import Core
import Shared

open class DefaultPageViewModel: PageViewModel<DefaultLoaderProps, DefaultPlaceholderProps, DefaultErrorProps> {

    @Published public var isShowingSnack: Bool = false

    override public func defaultPageErrorHandler(_ error: CoreError, action: VoidHandler?) {
        let props: DefaultErrorProps? = switch error {
        case .networkError(let error):
                .common(message: error.description, action: action)
        case .storageError(let error):
                .common(message: error.description, action: action)
        case .validationError(let error):
                .common(message: error.description, action: action)
        default:
                .common(message: "Unknown error", action: action)
        }
        if let props {
            presentErrorPage(withProps: props)
        }
    }

    override public func presentErrorPage(withProps errorProps: DefaultErrorProps) {
        additionalState = .error(errorProps)
    }

    override public func loadingStarted() {
        additionalState = .loading()
    }
}
