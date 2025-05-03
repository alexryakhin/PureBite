//
//  UserDefaults.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/2/24.
//

import Foundation

public enum UserDefaultsKey: String {
    case recipeSearchQueries
    case ingredientSearchQueries
    case productSearchQueries
}

public protocol UserDefaultsServiceInterface: AnyObject {

    func save(string: String?, forKey key: UserDefaultsKey)
    func save(bool: Bool, forKey key: UserDefaultsKey)
    func save(strings: [String], forKey key: UserDefaultsKey)
    func loadString(forKey key: UserDefaultsKey) -> String?
    func loadBool(forKey key: UserDefaultsKey) -> Bool
    func loadStrings(forKey key: UserDefaultsKey) -> [String]
}

public final class UserDefaultsService: NSObject, UserDefaultsServiceInterface {

    public override init() {
        super.init()
    }

    public func save(string: String?, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(string, forKey: key.rawValue)
    }

    public func save(bool: Bool, forKey key: UserDefaultsKey) {
        UserDefaults.standard.set(bool, forKey: key.rawValue)
    }

    public func save(strings: [String], forKey key: UserDefaultsKey) {
        if let data = try? PropertyListEncoder().encode(strings) {
            UserDefaults.standard.set(data, forKey: key.rawValue)
        }
    }

    public func loadString(forKey key: UserDefaultsKey) -> String? {
        UserDefaults.standard.string(forKey: key.rawValue)
    }

    public func loadBool(forKey key: UserDefaultsKey) -> Bool {
        UserDefaults.standard.bool(forKey: key.rawValue)
    }

    public func loadStrings(forKey key: UserDefaultsKey) -> [String] {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue),
              let array = try? PropertyListDecoder().decode([String].self, from: data) else {
            return []
        }
        return array
    }
}
