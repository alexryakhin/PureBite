import Combine
import UIKit

public final class TabBarView: BaseView {

    // MARK: - Public Properties

//    public var onItemTap: ((TabBarItem) -> Void?)?
    public var onItemTap: IntHandler?

    public var activeItem: Int = 0

    // MARK: - Private Properties

    private var itemsStack = KHStack(distribution: .fillEqually, content: {})

    // MARK: - Lifecycle

    public convenience init(tabItems: [TabBarItem]) {
        self.init()
        backgroundColor = .systemBackground
        itemsStack.embed(in: self, top: 0, leading: 16, bottom: 0, trailing: 16, useSafeAreaGuide: false)

        tabItems.forEach { item in
            let tabItemView = TabBarItemView(item: item)
            tabItemView.onTap { [unowned self, unowned tabItemView] in
                self.switchTab(from: activeItem, to: tabItemView)
            }
            itemsStack.addArrangedSubview(tabItemView)
        }

        activateTab(tabIndex: 0)
    }

    // MARK: - Public Methods

    public func forceSwitchTab(to tabIndex: Int) {
        guard tabIndex + 1 <= itemsStack.arrangedSubviews.count else { return }
        let view = itemsStack.arrangedSubviews[tabIndex]
        switchTab(from: activeItem, to: view)
    }

    // MARK: - Private Methods

    /// Will deactivate previous tab and activate next
    private func switchTab(from previousTabIndex: Int, to nextTab: UIView) {
        guard let view = nextTab as? TabBarItemView,
              let nextTabIndex = itemsStack.arrangedSubviews.firstIndex(of: view),
              nextTabIndex != previousTabIndex
        else { return }

        deactivateTab(tabIndex: previousTabIndex)
        activateTab(tabIndex: nextTabIndex)
    }

    /// Turns on tab after tap
    private func activateTab(tabIndex: Int) {
        guard let tabToActivate = itemsStack.arrangedSubviews[tabIndex] as? TabBarItemView else {
            return
        }

        tabToActivate.toggleIcon(
            isSelected: true,
            isNotificationAvailable: isNotificationAvailable(itemIndex: tabIndex)
        )

//        onItemTap?(.init(rawValue: tabIndex) ?? .main)
        onItemTap?(tabIndex)
        activeItem = tabIndex
    }

    /// Turns off tab after tap on another
    private func deactivateTab(tabIndex: Int) {
        guard let tabToDeactivate = itemsStack.arrangedSubviews[tabIndex] as? TabBarItemView else {
            return
        }
        tabToDeactivate.toggleIcon(
            isSelected: false,
            isNotificationAvailable: isNotificationAvailable(itemIndex: tabIndex)
        )
    }

    private func isNotificationAvailable(itemIndex: Int) -> Bool {
        // TODO: - Add Notifications Provider
        return false
    }
}
