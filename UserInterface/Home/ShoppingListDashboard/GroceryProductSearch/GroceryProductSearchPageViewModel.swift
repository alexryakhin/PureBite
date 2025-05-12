import Foundation
import Combine
import Core
import CoreUserInterface
import Shared
import Services

public final class GroceryProductSearchPageViewModel: DefaultPageViewModel {

    enum Input {
        case search(String)
    }

    enum Output {

    }

    var onOutput: ((Output) -> Void)?

    @Published var searchTerm: String = .empty
    @Published var fetchStatus: PaginationFetchStatus = .initial
    @Published var searchResults: [GroceryProductShortInfo] = []

    // MARK: - Private Properties

    private let groceryProductSearchRepository: GroceryProductSearchRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(groceryProductSearchRepository: GroceryProductSearchRepository) {
        self.groceryProductSearchRepository = groceryProductSearchRepository
        super.init()
        setupBindings()
        additionalState = .placeholder()
    }

    // MARK: - Public Methods

    func handle(_ input: Input) {
        switch input {
        case .search(let query):
            groceryProductSearchRepository.search(query: query)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        groceryProductSearchRepository.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.searchResults = items
            }
            .store(in: &cancellables)

        groceryProductSearchRepository.fetchStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.fetchStatus = status
                switch status {
                case .loadingFirstPage:
                    self?.additionalState = .loading()
                case .loadingNextPage:
                    break // show loading view below the list of results
                case .nextPageLoadingError:
                    break // show error view below the list of results
                case .firstPageLoadingError:
                    self?.errorReceived(CoreError.unknownError, displayType: .page)
                case .initial:
                    self?.additionalState = .placeholder()
                case .idle:
                    self?.additionalState = nil
                case .idleNoData:
                    self?.additionalState = .placeholder()
                @unknown default:
                    fatalError("Unknown fetch status: \(status)")
                }
            }
            .store(in: &cancellables)
    }
}
