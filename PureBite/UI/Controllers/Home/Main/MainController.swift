import UIKit
import Combine
import EnumsMacros
import EventSenderMacro

@EventSender
public final class MainController: ViewController {

    @PlainedEnum
    public enum Event {
        case openRecipeDetails(id: Int)
    }

    // MARK: - Private properties

    private let viewModel: MainViewModel
    private var suiView: MainView

    // MARK: - Initialization

    public init(viewModel: MainViewModel) {
        let suiView = MainView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        additionalSafeAreaInsets.bottom = UiConstant.tabBarHeight
        embed(swiftUiView: suiView)
        setupBindings()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
        viewModel.on { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.send(event: .openRecipeDetails(id: id))
            }
        }
    }
}
