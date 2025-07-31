import Foundation
import Combine
import SwiftUI

@MainActor
final class MainPageSearchViewModel: SwiftUIBaseViewModel {

    enum Event {
        case openRecipeDetails(recipeShortInfo: RecipeShortInfo)
        case activateSearch(query: String?)
    }

    enum Input {
        case loadNextPage
        case activateSearch
        case finishSearch
        case search
        case applyFilters
        case clearRecentQueries
    }

    var onEvent: ((Event) -> Void)?

    @Published var searchQueries: [String] = []
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
    private let userDefaultsService: UserDefaultsService
    private var cancellables = Set<AnyCancellable>()

    override init() {
        self.recipeSearchRepository = RecipeSearchRepository()
        self.userDefaultsService = UserDefaultsService.shared
        super.init()
        setup()
        setupBindings()
    }

    func handle(_ input: Input) {
        switch input {
        case .loadNextPage:
            recipeSearchRepository.loadNextPage()
        case .activateSearch:
            onEvent?(.activateSearch(query: searchTerm.nilIfEmpty))
        case .search:
            search(searchTerm)
        case .finishSearch:
            searchResults.removeAll()
            searchTerm = .empty
            recipeSearchRepository.reset()
        case .applyFilters:
            recipeSearchRepository.search(query: searchTerm)
        case .clearRecentQueries:
            userDefaultsService.save(strings: [], forKey: .recipeSearchQueries)
            searchQueries = []
        }
    }

    // MARK: - Private Methods

    private func setup() {
        searchQueries = userDefaultsService.loadStrings(forKey: .recipeSearchQueries)
    }

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
                    self?.setLoading(true)
                case .loadingNextPage:
                    break // show loading view below the list of results
                case .nextPageLoadingError:
                    break // show error view below the list of results
                case .firstPageLoadingError:
                    self?.handleError(CoreError.unknownError)
                case .initial:
                    break
                case .idle:
                    self?.setLoading(false)
                case .idleNoData:
                    break
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

        $searchTerm.combineLatest($fetchStatus)
            .sink { [weak self] newValue, fetchStatus in
                if newValue.isEmpty && fetchStatus != .initial {
                    self?.handle(.finishSearch)
                    self?.fetchStatus = .initial
                }
            }
            .store(in: &cancellables)
    }

    private func search(_ query: String) {
        // Save to recent queries if not already present
        if !query.isEmpty && !searchQueries.contains(query) {
            searchQueries.insert(query, at: 0)
            searchQueries = Array(searchQueries.prefix(10)) // Keep only the last 10
            userDefaultsService.save(strings: searchQueries, forKey: .recipeSearchQueries)
        }

        recipeSearchRepository.search(query: query)
    }
}
