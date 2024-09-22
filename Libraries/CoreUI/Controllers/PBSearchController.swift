//
//  PBSearchController.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/21/24.
//

import UIKit

final public class PBSearchController: UISearchController, UISearchBarDelegate {

    public var onSearchButtonClick: (() -> Void)?
    public var onCancelButtonClick: (() -> Void)?

    override init(searchResultsController: UIViewController? = nil) {
        super.init(searchResultsController: searchResultsController)
        customizeSearchBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customizeSearchBar()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetNavBarAppearance()
    }

    private func customizeSearchBar() {
        searchBar.delegate = self
        let searchTextField = searchBar.searchTextField
        searchTextField.layer.cornerRadius = 18
        searchTextField.layer.masksToBounds = true
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        onCancelButtonClick?()
    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        onSearchButtonClick?()
    }

    private func resetNavBarAppearance() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        // Apply the appearance to the navigation bar
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
}
