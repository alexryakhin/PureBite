import Foundation
import Combine
import Core
import CoreUserInterface
import Shared
import Services

public final class DebugPageViewModel: DefaultPageViewModel {

    public enum Input {
        case toggleFeature(feature: FeatureToggle)
    }

    public enum Event {
        case finish
    }

    public var onEvent: ((Event) -> Void)?

    @Published var featureToggles: FeatureToggles = [:]

    // MARK: - Private Properties

    private let featureToggleService: FeatureToggleServiceInterface
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(featureToggleService: FeatureToggleServiceInterface) {
        self.featureToggleService = featureToggleService
        super.init()

        setupBindings()
    }

    public func handle(_ input: Input) {
        switch input {
        case .toggleFeature(let feature):
            featureToggleService.featureToggles.value[feature]?.toggle()
        }
    }

    // MARK: - Private Methods

    private func setupBindings() {
        featureToggleService.featureToggles
            .receive(on: RunLoop.main)
            .assign(to: \.featureToggles, on: self)
            .store(in: &cancellables)
    }
}
