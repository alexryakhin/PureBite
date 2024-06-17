import Combine
import EnumsMacros
import EventSenderMacro
import Foundation

@EventSender
public final class MainViewModel: DefaultPageViewModel<MainContentProps> {

    @PlainedEnum
    public enum Event {
        case openRecipeDetails(id: Int)
    }

    // MARK: - Private Properties

    private let spoonacularNetworkService: SpoonacularNetworkServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(spoonacularNetworkService: SpoonacularNetworkServiceInterface) {
        self.spoonacularNetworkService = spoonacularNetworkService
        super.init()

        setInitialState()
        setupBindings()
    }

    // MARK: - Public Methods

    public func retry() {

    }

    // MARK: - Private Methods

    private func setupBindings() {
        state.contentProps.on { [weak self] event in
            switch event {
            case .searchRecipies(let searchTerm):
                self?.searchRecipies(searchTerm)
            case .openRecipeDetails(let id):
                self?.send(event: .openRecipeDetails(id: id))
                self?.recipeInfo(id)
            }
        }
    }

    private func searchRecipies(_ searchTerm: String) {
        Task {
            do {
                let response = try await spoonacularNetworkService.fetchRecipes(query: searchTerm)
                state.contentProps.recipes = response.results
            } catch {
                errorReceived(error, contentPreserved: true)
            }
        }
    }

    private func recipeInfo(_ id: Int) {
        Task {
            do {
                let response = try await spoonacularNetworkService.recipeInformation(id: id)
                print("DEBUG: \(response)")
            } catch {
                errorReceived(error, contentPreserved: true)
            }
        }
    }

    private func setInitialState() {
        state = .init(contentProps: .initial())
    }
}

