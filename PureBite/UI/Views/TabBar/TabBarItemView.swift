import UIKit
import Combine

final class TabBarItemView: RSView {

    // MARK: - Private Properties

    private var tabBarItem: TabBarItem?
    private var isSelected: Bool = false {
        didSet { updateItem() }
    }
    private var isNotificationAvailable: Bool = false {
        didSet { updateItem() }
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Layout Properties

    // Invisible if this is a profile tab and user is logged in
    private let iconView = ImageView()
        .size(sideLength: 24)

    // Always visible
    private let titleLabel = KLabel()
        .fontStyle(.caption1)
        .foregroundStyle(.accent)
        .textAlignment(.center)

    // MARK: - Lifecycle

    convenience init(item: TabBarItem) {
        self.init()
        tabBarItem = item
        titleLabel.text = item.displayTitle
        iconView.image = item.icon
        updateItem()
    }

    override func setup() {
        super.setup()
        setupLayout()
        updateItem()
    }

    // MARK: - Public Methods

    func toggleIcon(isSelected: Bool, isNotificationAvailable: Bool) {
        self.isSelected = isSelected
        self.isNotificationAvailable = isNotificationAvailable
    }

    // MARK: - Private Methods

    private func updateItem() {

        titleLabel.foregroundStyle(isSelected ? .accent : .secondary)

        switch (isSelected, isNotificationAvailable) {
        case (true, _):
            iconView.image = tabBarItem?.icon
            iconView.foregroundStyle(.accent)
        case (false, true):
            iconView.image = tabBarItem?.iconNotify
            iconView.foregroundStyle(.disabled)
        case (false, false):
            iconView.image = tabBarItem?.icon
            iconView.foregroundStyle(.disabled)
        }
    }

    private func setupLayout() {
        BaseBackgroundView(leftPadding: 0, right: 0, top: 2, bottom: 0) {
            KVStack(alignment: .center) {
                KZStack {
                    iconView
                }
                titleLabel
            }
        }.embed(in: self)
    }
}
