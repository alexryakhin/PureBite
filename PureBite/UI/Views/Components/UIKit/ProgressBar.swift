import UIKit

final class ProgressBar: RSView {

    private let progressLayer = CALayer()
    private var progress: CGFloat

    init(progress: CGFloat = 0) {
        self.progress = min(max(0, progress), 1)
        super.init(frame: .zero)
        layer.addSublayer(progressLayer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        backgroundColor = UIColor.systemBackground
    }

    override func draw(_ rect: CGRect) {
        let backgroundMask = CAShapeLayer()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.5).cgPath
        layer.mask = backgroundMask

        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))

        progressLayer.cornerRadius = rect.height * 0.5
        progressLayer.frame = progressRect
        progressLayer.backgroundColor = UIColor.accent.cgColor
    }

    public func setProgress(_ progress: CGFloat) {
        self.progress = min(max(0, progress), 1)
        setNeedsDisplay()
    }
}
