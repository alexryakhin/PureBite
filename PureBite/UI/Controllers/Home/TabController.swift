import UIKit

public final class TabController: UITabBarController {

    // MARK: - Public Properties

    public var controllers = [NavigationController]() {
        didSet {
            viewControllers = controllers
            selectedIndex = 0
        }
    }

    // MARK: - Private Properties

    // MARK: - LifeCycle Methods

    public required init() {
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationItem.backButtonTitle = ""
    }

    // MARK: - Public Methods

    public func forceSwitchTab(to tabIndex: Int) {
//        customTabBar.forceSwitchTab(to: tabIndex)
        selectedIndex = tabIndex
    }

    // MARK: - Private Methods

}
