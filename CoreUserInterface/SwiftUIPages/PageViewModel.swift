//
//  AnyPageViewModel.swift
//  Suint One
//
//  Created by Aleksandr Riakhin on 9/30/24.
//

import Combine
import SwiftUI
import Core
import Shared

open class PageViewModel<
    LoaderProps,
    PlaceholderProps,
    ErrorProps
>: ObservableObject {

    public typealias PageState = AdditionalPageState<LoaderProps, PlaceholderProps, ErrorProps>

    // MARK: - Properties

    @Published public var additionalState: PageState?

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    public init() { }

    public func setState(_ newState: PageState) {
        additionalState = newState
    }

    public func resetAdditionalState() {
        withAnimation {
            additionalState = nil
        }
    }

    public func errorReceived(
        _ error: Error,
        displayType: ErrorDisplayType,
        action: VoidHandler? = nil
    ) {
        fault("Error received: \(error)")
        guard let errorWithContext = error as? CoreError else {
            print("Unexpectedly receive `Error` which is not `CoreError`")
            return
        }
        defaultErrorReceived(errorWithContext, displayType: displayType, action: action)
    }

    /// Override this function to implement custom error processing
    public func defaultErrorReceived(
        _ error: CoreError,
        displayType: ErrorDisplayType,
        action: VoidHandler? = nil
    ) {
        switch displayType {
        case .page:
            defaultPageErrorHandler(error, action: action)
        case .none:
            return
        }
    }

    func defaultPageErrorHandler(_ error: CoreError, action: VoidHandler?) {
        assertionFailure()
    }

    func presentErrorPage(withProps errorProps: ErrorProps) {
        assertionFailure()
    }

    func loadingStarted() {
        assertionFailure()
    }
}
