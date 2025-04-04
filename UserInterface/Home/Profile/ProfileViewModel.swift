import Foundation
import Combine
import Core
import CoreUserInterface
import Shared
import Services

public final class ProfilePageViewModel: DefaultPageViewModel {

    public enum Event {
        case finish
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Private Properties

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init(arg: Int) {
        super.init()

        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {}
}
