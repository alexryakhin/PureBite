import UIKit

public enum TabBarItem: Int, CaseIterable {

    case main, tab2, tab3, tab4, profile

    var displayTitle: String {
        switch self {
        case .main:
            return "Main"
        case .tab2:
            return "tab2"
        case .tab3:
            return "tab3"
        case .tab4:
            return "tab4"
        case .profile:
            return "tab5"
        }
    }

    var icon: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "house")
        case .tab2:
            return UIImage(systemName: "2.circle")
        case .tab3:
            return UIImage(systemName: "3.circle")
        case .tab4:
            return UIImage(systemName: "4.circle")
        case .profile:
            return UIImage(systemName: "5.circle")
        }
    }

    var iconNotify: UIImage? {
        switch self {
        case .main:
            return nil
        case .tab2:
            return nil
        case .tab3:
            return nil
        case .tab4:
            return nil
        case .profile:
            return nil
        }
    }
}
