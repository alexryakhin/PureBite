import UIKit

public final class BaseWindow: UIWindow {
    #if DEBUG
    public var onShakeDetected: (() -> Void)?
    #endif

    override public func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        #if DEBUG
        if motion == .motionShake {
            onShakeDetected?()
        }
        #endif
    }

    override public init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
