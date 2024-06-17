import SnapKit

final class SheetTopView: BaseView, ConfigurableView {

    // MARK: - Types

    typealias Model = Props

    struct Props {
        let title: String
    }

    // MARK: - Public Peoperties

    var onDone: VoidHandler?

    // MARK: - Private Properties

    private let titleLabel = KLabel().fontStyle(.headline)

    // MARK: - Lifecycle

    override func setup() {
        super.setup()
        body().embed(in: self)
        addRightButton()
    }

    // MARK: - Public Methods

    func configure(with model: Model) {
        titleLabel.text(model.title)
    }

    @discardableResult
    func onDone(_ completion: @escaping VoidHandler) -> Self {
        onDone = completion
        return self
    }

    // MARK: - Private Methods

    private func body() -> KHStack {
        KHStack {
            FlexibleGroupedSpacer()
            titleLabel
            FlexibleGroupedSpacer()
        }
        .linkGroupedSpacers()
        .height(44)
    }

    private func addRightButton() {
        let rightBarButton = ButtonText(title: "Done")
            .onTap { [weak self] in
                guard let self = self else { return }
                self.onDone?()
            }
        addSubview(rightBarButton)
        rightBarButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.equalTo(100) // FIXME: - Hard coded for now, fix flexible spacer later
        }
    }
}
