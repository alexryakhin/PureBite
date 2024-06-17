#if DEBUG
import SwinjectAutoregistration

final class FeatureTogglesViewController: ViewController {

    private let featureToggleService = DIContainer.shared.resolver ~> FeatureToggleServiceInterface.self

    override public func setup() {
        super.setup()
        embed(swiftUiView: FeatureTogglesView(featureToggleService: featureToggleService))
    }
}

#endif
