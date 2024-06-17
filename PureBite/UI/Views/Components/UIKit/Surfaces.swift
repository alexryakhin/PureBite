// swiftlint:disable final_class

public class BackgroundPrimary: RSView {
    override public func setup() {
        backgroundStyle(.backgroundPrimary)
        super.setup()
    }
}

public class SurfacePrimary: RSView {
    override public func setup() {
        backgroundStyle(.surfacePrimary)
        super.setup()
    }
}

// swiftlint:enable final_class

final class Overlay: RSView {
    override func setup() {
        backgroundStyle(.surfaceOpacity)
        super.setup()
    }
}
