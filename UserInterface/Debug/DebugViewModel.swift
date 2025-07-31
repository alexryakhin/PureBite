import Foundation
import Combine

@MainActor
public final class DebugViewModel: SwiftUIBaseViewModel {

    public enum Input {
        case toggleFeature(feature: FeatureToggle)
    }

    public enum Event {
        case finish
    }

    public var onEvent: ((Event) -> Void)?

    @Published var featureToggles: FeatureToggles = [:]

    // MARK: - Private Properties

    private let featureToggleService: FeatureToggleService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public override init() {
        self.featureToggleService = FeatureToggleService.shared
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
