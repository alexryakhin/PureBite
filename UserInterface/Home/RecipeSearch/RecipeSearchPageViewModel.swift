import Foundation
import Combine
import SwiftUI
import Core
import CoreUserInterface
import Shared
import Services

public final class RecipeSearchPageViewModel: DefaultPageViewModel {

    public enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
        case activateSearch(query: String?)
    }

    public enum Input {
        case loadNextPage
        case activateSearch
        case finishSearch
        case search(query: String)
        case applyFilters
    }

    public var onEvent: ((Event) -> Void)?

    @AppStorage(UserDefaultsKey.searchQueries.rawValue) private var searchQueries: String = .empty

    @Published var isSearchFocused: Bool = false
    @Published var isFilterSheetPresented: Bool = false
    @Published var searchTerm: String = .empty
    @Published var searchResults: [RecipeShortInfo] = []
    @Published var fetchStatus: PaginationFetchStatus = .initial
    @Published var filters: RecipeSearchFilters = .init()
    var totalResults: Int {
        recipeSearchRepository.totalResults
    }

    var canLoadNextPage: Bool {
        recipeSearchRepository.canLoadNextPage
    }

    // MARK: - Private Properties

    private let recipeSearchRepository: RecipeSearchRepository
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(recipeSearchRepository: RecipeSearchRepository) {
        self.recipeSearchRepository = recipeSearchRepository
        super.init()
        setupBindings()
    }

    public func handle(_ input: Input) {
        switch input {
        case .loadNextPage:
            recipeSearchRepository.loadNextPage()
        case .activateSearch:
            onEvent?(.activateSearch(query: searchTerm.nilIfEmpty))
        case .search(let query):
            recipeSearchRepository.search(query: query)
        case .finishSearch:
            searchResults.removeAll()
            searchTerm = .empty
            isSearchFocused = false
            additionalState = .placeholder()
            recipeSearchRepository.reset()
        case .applyFilters:
            recipeSearchRepository.search(query: searchTerm)
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        recipeSearchRepository.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] recipes in
                self?.searchResults = recipes
            }
            .store(in: &cancellables)

        recipeSearchRepository.fetchStatusPublisher
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

        $filters
            .sink { [weak self] in
                self?.recipeSearchRepository.filters = $0
            }
            .store(in: &cancellables)
    }
}
