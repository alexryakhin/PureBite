import Combine
import EnumsMacros
import EventSenderMacro
import UIKit

@EventSender
public final class RecipeDetailsViewModel: DefaultPageViewModel<RecipeDetailsContentProps> {

    @PlainedEnum
    public enum Event {
        case finish
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
    }

    private func setInitialState() {
        state = .init(contentProps: .initial())
    }
}
