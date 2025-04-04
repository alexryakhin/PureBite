import UIKit
import Combine
import Core
import CoreUserInterface
import Shared

public final class RecipeDetailsController: PageViewController<RecipeDetailsPageView> {

    public enum Event {
        case finish
        case showIngredientInformation(IngredientDetailsPageViewModel.Config)
    }
    public var onEvent: ((Event) -> Void)?

    // MARK: - Private properties
    private let viewModel: RecipeDetailsPageViewModel

    // MARK: - Initialization

    public init(viewModel: RecipeDetailsPageViewModel) {
        self.viewModel = viewModel
        super.init(rootView: RecipeDetailsPageView(viewModel: viewModel))
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func setup() {
        super.setup()
        setupBindings()
        setupNavBarTitle()
    }

    public override func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
        setupTransparentNavBar()
    }

    /// Set up the custom title view (UILabel in this case)
    private func setupNavBarTitle() {
        let titleLabel = UILabel()
        titleLabel.text = viewModel.config.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        titleLabel.isHidden = true
        navigationItem.titleView = titleLabel
    }

    private func setupFavoriteButton(isFavorite: Bool) {
        navigationItem.rightBarButtonItem = .init(
            image: UIImage(systemName: isFavorite ? "bookmark.fill" : "bookmark"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
    }

    // MARK: - Private Methods

    private func setupBindings() {
        viewModel.onEvent = { [weak self] event in
            switch event {
            case .finish:
                self?.onEvent?(.finish)
            case .showIngredientInformation(let config):
                self?.onEvent?(.showIngredientInformation(config))
            }
        }
        viewModel.$isNavigationTitleOnScreen
            .sink { [weak self] isShowing in
                UIView.animate(withDuration: 0.25) {
                    self?.navigationItem.titleView?.alpha = isShowing ? 0 : 1
                    self?.navigationItem.titleView?.isHidden = isShowing
                }
            }
            .store(in: &cancellables)

        viewModel.$isFavorite
            .sink { [weak self] isFavorite in
                self?.setupFavoriteButton(isFavorite: isFavorite)
            }
            .store(in: &cancellables)

    }

    @objc private func favoriteButtonTapped() {
        viewModel.handle(.favorite)
    }
}
