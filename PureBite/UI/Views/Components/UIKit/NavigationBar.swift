import UIKit

public final class NavigationBar: BaseNavigationBar {

    override public func setup() {
        super.setup()
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            // Add iPad-specific customization
//            let appearance = UINavigationBarAppearance()
//            appearance.configureWithOpaqueBackground()
//            appearance.backgroundColor = .systemBackground
//
//            standardAppearance = appearance
//            scrollEdgeAppearance = appearance
//        }
    }
}

extension UINavigationItem {

    func set(title: String, subtitle: String) {
        let titleLabel = KLabel(text: title)
            .textStyle(.title3)
            .textColor(.label)
            .textAlignment(.center)

        let subtitleLabel = KLabel(text: subtitle)
            .textStyle(.caption1)
            .textColor(.secondaryLabel)
            .textAlignment(.center)

        let stack = KVStack(alignment: .center, distribution: .equalCentering) {
            titleLabel
            subtitleLabel
        }

        self.titleView = stack
    }
}
