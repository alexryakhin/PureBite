//
//  UserDefaults.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 10/2/24.
//

import Foundation
import Core
import Shared

@MainActor
public final class UserDefaultsService: ObservableObject {
    public static let shared = UserDefaultsService()
    
    private let userDefaults = UserDefaults.standard
    
    private init() {
        setup()
    }
    
    private func setup() {
        // Any additional setup if needed
    }
    
    // MARK: - String Operations
    
    public func save(_ string: String, forKey key: UserDefaultsKey) {
        userDefaults.set(string, forKey: key.rawValue)
    }
    
    public func loadString(forKey key: UserDefaultsKey) -> String {
        return userDefaults.string(forKey: key.rawValue) ?? ""
    }
    
    // MARK: - String Array Operations
    
    public func save(strings: [String], forKey key: UserDefaultsKey) {
        userDefaults.set(strings, forKey: key.rawValue)
    }
    
    public func loadStrings(forKey key: UserDefaultsKey) -> [String] {
        return userDefaults.stringArray(forKey: key.rawValue) ?? []
    }
    
    // MARK: - Integer Operations
    
    public func save(_ integer: Int, forKey key: UserDefaultsKey) {
        userDefaults.set(integer, forKey: key.rawValue)
    }
    
    public func loadInteger(forKey key: UserDefaultsKey) -> Int {
        return userDefaults.integer(forKey: key.rawValue)
    }
    
    // MARK: - Boolean Operations
    
    public func save(_ bool: Bool, forKey key: UserDefaultsKey) {
        userDefaults.set(bool, forKey: key.rawValue)
    }
    
    public func loadBool(forKey key: UserDefaultsKey) -> Bool {
        return userDefaults.bool(forKey: key.rawValue)
    }
    
    // MARK: - Data Operations
    
    public func save(_ data: Data, forKey key: UserDefaultsKey) {
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    public func loadData(forKey key: UserDefaultsKey) -> Data? {
        return userDefaults.data(forKey: key.rawValue)
    }
    
    // MARK: - Object Operations
    
    public func save<T: Encodable>(_ object: T, forKey key: UserDefaultsKey) {
        do {
            let data = try JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key.rawValue)
        } catch {
            fault("Failed to save object for key \(key.rawValue): \(error)")
        }
    }
    
    public func loadObject<T: Decodable>(forKey key: UserDefaultsKey) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            fault("Failed to load object for key \(key.rawValue): \(error)")
            return nil
        }
    }
    
    // MARK: - Clear Operations
    
    public func clear(forKey key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
    
    public func clearAll() {
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
    }
}
