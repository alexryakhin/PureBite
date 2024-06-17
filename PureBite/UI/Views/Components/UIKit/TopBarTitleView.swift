import UIKit

final class TopBarTitleView: BaseView {

    private let titleLabel = KLabel()
        .fontStyle(.body)
        .textColor(.label)

    private lazy var content = BaseBackgroundView(padding: 8) {
        titleLabel
    }
        .backgroundColor(.systemBackground)
        .cornerRadius(16)

    convenience init(title: String) {
        self.init(frame: .zero)
        titleLabel.text(title)
    }

    override func setup() {
        super.setup()
        setupView()
    }

    private func setupView() {
        addSubview(content)
        content.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.centerX.equalToSuperview()
        }
    }
}
