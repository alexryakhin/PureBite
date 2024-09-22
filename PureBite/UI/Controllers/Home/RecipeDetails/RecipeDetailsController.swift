import UIKit
import Combine

public final class RecipeDetailsController: ViewController {

    public enum Event {
        case finish
    }
    var onEvent: ((Event) -> Void)?

    // MARK: - Private properties
    private let viewModel: RecipeDetailsViewModel
    private var suiView: RecipeDetailsView

    // MARK: - Initialization

    public init(viewModel: RecipeDetailsViewModel) {
        let suiView = RecipeDetailsView(viewModel: viewModel)
        self.suiView = suiView
        self.viewModel = viewModel
        super.init()
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        embed(swiftUiView: suiView)
        setupBindings()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = viewModel.recipe?.title
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )

//         Set up the custom title view (UILabel in this case)
//        titleLabel.text = viewModel.state.contentProps.recipe.title
//        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
//        titleLabel.textAlignment = .center
//        titleLabel.alpha = 0 // Initially hidden
//        navigationItem.titleView = titleLabel
        setupTransparentNavBar()
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.snacksDisplay = self
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.onEvent?(.finish)
            case .handleScroll(let offset):
                let opacity = min(max(-offset / 70, 0), 1)
                self?.navigationItem.titleView?.alpha = opacity
            }
        }
    }

    @objc private func favoriteButtonTapped() {

    }
}
