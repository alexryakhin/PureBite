//
//  UserDefaults.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/2/24.
//

import Foundation

public enum UserDefaultsKey: String {
    case searchQueries
    case ingredientSearchQueries
}

public protocol UserDefaultsServiceInterface: AnyObject {

    func save(string: String?, forKey key: UserDefaultsKey)
    func save(bool: Bool, forKey key: UserDefaultsKey)
    func loadString(forKey key: UserDefaultsKey) -> String?
    func loadBool(forKey key: UserDefaultsKey) -> Bool
}

final class UserDefaultsService: NSObject, UserDefaultsServiceInterface {

    func save(string: String?, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(string, forKey: key.rawValue)
    }

    func save(bool: Bool, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(bool, forKey: key.rawValue)
    }

    func loadString(forKey key: UserDefaultsKey) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }

    func loadBool(forKey key: UserDefaultsKey) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }
}
