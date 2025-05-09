//
//  PageViewController.swift
//  Suint One
//
//  Created by Aleksandr Riakhin on 9/30/24.
//

import SwiftUI
import UIKit
import class Combine.AnyCancellable

open class PageViewController<Content: PageView>: UIHostingController<Content> {

    public var cancellables: Set<AnyCancellable> = []

    override public init(rootView: Content) {
        super.init(rootView: rootView)
        setup()
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self is NavigationBarHidden {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        } else if self is NavigationBarVisible {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
        setupNavigationBar(animated: animated)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setupNavigationBar(animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    open func setup() {
        view.backgroundColor = .background
    }

    public final func activateSearch(query: String?) {
        navigationItem.searchController?.searchBar.text = query
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.navigationItem.searchController?.isActive = true
            self?.navigationItem.searchController?.searchBar.becomeFirstResponder()
        }
    }

    public final func setupTransparentNavBar() {
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

    public final func resetNavBarAppearance() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        let scrollEdgeAppearance = UINavigationBarAppearance()
        scrollEdgeAppearance.configureWithTransparentBackground()
        // Apply the appearance to the navigation bar
        navigationController?.navigationBar.standardAppearance = standardAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = scrollEdgeAppearance
    }
}
