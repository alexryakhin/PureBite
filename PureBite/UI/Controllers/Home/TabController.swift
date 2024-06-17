import UIKit

public final class TabController: UITabBarController {

    // MARK: - Public Properties

    public var controllers = [NavigationController]() {
        didSet {
            viewControllers = controllers
            setupCustomTabMenu()
            setupBindings()
            selectedIndex = 0
        }
    }

    // MARK: - Private Properties

    private var customTabBar: TabBarView!
    private var k_isTabBarHidden: Bool = false

    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor(.separator)
        view.height(.onePixel)
        return view
    }()

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
        customTabBar.forceSwitchTab(to: tabIndex)
    }

    public func showTabBar(completion: BoolHandler? = nil) {
        guard k_isTabBarHidden else { return }

        k_isTabBarHidden = false
        tabBar.isHidden = true

        let tabBarAnimation = {
            self.customTabBar.transform = .identity
        }

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: tabBarAnimation,
            completion: completion
        )
    }

    public func hideTabBar(completion: BoolHandler? = nil) {
        guard !k_isTabBarHidden else { return }
        k_isTabBarHidden = true

        let tabBarAnimation = {
            self.customTabBar.transform = CGAffineTransform(
                translationX: 0,
                y: UiConstant.tabBarHeightWithSafeArea
            )
        }

        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: .curveEaseIn,
            animations: tabBarAnimation,
            completion: completion
        )
    }

    // MARK: - Private Methods

    private func setupCustomTabMenu() {
        tabBar.isHidden = true
        let tabs: [TabBarItem] = TabBarItem.allCases
        customTabBar = TabBarView(tabItems: tabs)
        customTabBar.clipsToBounds = true

        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view)
            $0.height.equalTo(UiConstant.tabBarHeightWithSafeArea)
        }

        customTabBar.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
        }
    }

    private func setupBindings() {
        customTabBar.onItemTap = { [weak self] tab in
            self?.selectedIndex = tab
        }
    }
}
