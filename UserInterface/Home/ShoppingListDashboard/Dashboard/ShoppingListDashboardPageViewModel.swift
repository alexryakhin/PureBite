import Foundation
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared
import Services

public final class ShoppingListDashboardPageViewModel: DefaultPageViewModel {

    public enum Output {
        case search(query: String)
    }

    public enum Input {
        case search
        case finishSearch
    }

    public var onOutput: ((Output) -> Void)?

    @Published var searchTerm: String = .empty

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public override init() {
        super.init()
    }

    public func handle(_ input: Input) {
        switch input {
        case .search:
            onOutput?(.search(query: searchTerm))
        case .finishSearch:
            searchTerm = .empty
        }
    }
}
