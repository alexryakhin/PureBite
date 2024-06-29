import Combine
import Swinject
import SwinjectAutoregistration
import EnumsMacros
import EventSenderMacro

@EventSender
final class MainCoordinator: Coordinator {

    @PlainedEnum
    enum Event {
        case authorize
    }

    // MARK: - Public Properties

    lazy var mainNavigationController = resolver ~> NavigationController.self

    // MARK: - Private Properties

    private let persistent: Persistent = resolver ~> Persistent.self
    private var innerRouter: RouterAbstract!

    // MARK: - Initialization

    required init(router: RouterAbstract) {
        super.init(router: router)
        innerRouter = Router(rootController: mainNavigationController)
    }

    override func start() {
        showMainController()
    }

    // MARK: - Private Methods

    private func showMainController() {
        let mainController = resolver ~> MainController.self

        mainController.on { [weak self] event in
            switch event {
            case .openRecipeDetails(let id):
                self?.openRecipeDetails(with: id)
            }
        }

        mainNavigationController.addChild(mainController)
    }

    private func openRecipeDetails(with id: Int) {
        //
    }

    private func showUnauthorizedAlert() {
        let signInAlert = UIAlertController(title: "Unauthorized", message: nil, preferredStyle: .alert)

        let signInAction = UIAlertAction(title: "Log in", style: .default, handler: { [weak self] _ in
            self?.send(event: .authorize)
        })
        signInAlert.addAction(signInAction)

        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        signInAlert.addAction(cancelButton)

        router.present(signInAlert, animated: true)
    }

    private func showUnderDevSnack() {
        SnackCenter.shared.showSnack(.init(message: "Under Development"))
    }
}
