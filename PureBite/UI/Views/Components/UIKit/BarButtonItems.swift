import UIKit

// swiftlint:disable:next final_class
public class ImageBarButtonItem: UIBarButtonItem {

    public convenience init(image: UIImage?, _ completion: @escaping VoidHandler) {
        let button = BaseButton(image: image)
            .tintColor(.accent)
            .onTap { completion() }

        self.init(customView: button)
    }
}

public final class BackBarButtonItem: ImageBarButtonItem {

    public convenience init(_ completion: @escaping VoidHandler) {
        self.init(image: UIImage(systemName: "chevron.left"), completion)
    }
}

public final class CloseBarButtonItem: ImageBarButtonItem {

    public convenience init(_ completion: @escaping VoidHandler) {
        self.init(image: UIImage(systemName: "xmark"), completion)
    }
}
