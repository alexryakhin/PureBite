import UIKit
import Combine

// swiftlint:disable:next final_class
open class ViewController: BaseController, SnacksDisplay {

    var snacksPresentingAvailable: Bool = false

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        snacksPresentingAvailable = true
        setupNavigationBar(animated: animated)
    }

    open func setupNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        snacksPresentingAvailable = false
    }

    func showSnack(withConfig snackConfig: SnackView.Config) {
        if snacksPresentingAvailable {
            SnackCenter.shared.showSnack(snackConfig)
        }
    }

    final func setupSearchBar(placeholder: String = "Search") {
        // Initialize the search controller
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = placeholder

        // Add the search bar to the navigation item
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true

        // Ensure the search bar is always visible
        definesPresentationContext = true
    }

    final func setupTransparentNavBar() {
        let appearance = UINavigationBarAppearance()

        // Configure the appearance with a transparent background
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear // Set to clear to ensure full transparency

        // Apply the appearance to the navigation bar
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // If you have a compact appearance, apply it as well
        navigationController?.navigationBar.compactAppearance = appearance
    }

    final func resetNavBarAppearance() {
        let appearance = UINavigationBarAppearance()

        // Apply the appearance to the navigation bar
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        // If you have a compact appearance, apply it as well
        navigationController?.navigationBar.compactAppearance = appearance
    }
}
