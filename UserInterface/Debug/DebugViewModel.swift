import Foundation
import Combine

@MainActor
final class DebugViewModel: SwiftUIBaseViewModel {

    enum Input {
        case toggleFeature(feature: FeatureToggle)
    }

    enum Event {
        case finish
    }

    var onEvent: ((Event) -> Void)?

    @Published var featureToggles: FeatureToggles = [:]

    // MARK: - Private Properties

    private let featureToggleService: FeatureToggleService
    private var cancellables = Set<AnyCancellable>()


    override init() {
        self.featureToggleService = FeatureToggleService.shared
        super.init()

        setupBindings()
    }

    func handle(_ input: Input) {
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
