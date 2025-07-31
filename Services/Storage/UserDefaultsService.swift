//
//  UserDefaults.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/2/24.
//

import Foundation

@MainActor
final class UserDefaultsService: ObservableObject {
    static let shared = UserDefaultsService()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        setup()
    }
    
    private func setup() {
        // Any additional setup if needed
    }
    
    // MARK: - String Operations
    
    func save(_ string: String, forKey key: UserDefaultsKey) {
        userDefaults.set(string, forKey: key.rawValue)
    }
    
    func loadString(forKey key: UserDefaultsKey) -> String {
        return userDefaults.string(forKey: key.rawValue) ?? ""
    }
    
    // MARK: - String Array Operations
    
    func save(strings: [String], forKey key: UserDefaultsKey) {
        userDefaults.set(strings, forKey: key.rawValue)
    }
    
    func loadStrings(forKey key: UserDefaultsKey) -> [String] {
        return userDefaults.stringArray(forKey: key.rawValue) ?? []
    }
    
    // MARK: - Integer Operations
    
    func save(_ integer: Int, forKey key: UserDefaultsKey) {
        userDefaults.set(integer, forKey: key.rawValue)
    }
    
    func loadInteger(forKey key: UserDefaultsKey) -> Int {
        return userDefaults.integer(forKey: key.rawValue)
    }
    
    // MARK: - Boolean Operations
    
    func save(_ bool: Bool, forKey key: UserDefaultsKey) {
        userDefaults.set(bool, forKey: key.rawValue)
    }
    
    func loadBool(forKey key: UserDefaultsKey) -> Bool {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    // MARK: - Data Operations
    
    func save(_ data: Data, forKey key: UserDefaultsKey) {
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    func loadData(forKey key: UserDefaultsKey) -> Data? {
        return userDefaults.data(forKey: key.rawValue)
    }
    
    // MARK: - Object Operations
    
    func save<T: Encodable>(_ object: T, forKey key: UserDefaultsKey) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key.rawValue)
        } catch {
            fault("Failed to save object for key \(key.rawValue): \(error)")
        }
    }
    
    func loadObject<T: Decodable>(forKey key: UserDefaultsKey) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fault("Failed to load object for key \(key.rawValue): \(error)")
            return nil
        }
    }
    
    // MARK: - Clear Operations
    
    func clear(forKey key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    func clearAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
    }
}
