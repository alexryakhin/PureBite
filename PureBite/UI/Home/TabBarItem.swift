//
//  TabBarItem.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/6/24.
//

import UIKit

public enum TabBarItem: Int, CaseIterable {

    case main, search, saved, shoppingList, profile

    var title: String {
        switch self {
        case .main:
            return "Main"
        case .search:
            return "Search"
        case .saved:
            return "Saved"
        case .shoppingList:
            return "Shopping List"
        case .profile:
            return "Profile"
        }
    }

    var image: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "house")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        case .saved:
            return UIImage(systemName: "bookmark")
        case .shoppingList:
            return UIImage(systemName: "list.bullet.rectangle.portrait")
        case .profile:
            return UIImage(systemName: "person")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .main:
            return UIImage(systemName: "house.fill")
        case .search:
            return UIImage(systemName: "magnifyingglass")
        case .saved:
            return UIImage(systemName: "bookmark.fill")
        case .shoppingList:
            return UIImage(systemName: "list.bullet.rectangle.portrait.fill")
        case .profile:
            return UIImage(systemName: "person.fill")
        }
    }

    @MainActor
    var item: UITabBarItem {
        UITabBarItem(title: title, image: image, selectedImage: selectedImage)
    }
}
