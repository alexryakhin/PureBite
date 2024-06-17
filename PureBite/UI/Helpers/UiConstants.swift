import UIKit

public enum UiConstant {

    public static let hasNotch: Bool = UIWindow.safeAreaBottomInset > 0
    public static let tabBarHeight: CGFloat = 48
    public static let tabBarHeightWithSafeArea: CGFloat = tabBarHeight + UIWindow.safeAreaBottomInset

    public static let defaultKeyboardButtonOffset: CGFloat = 12
}
