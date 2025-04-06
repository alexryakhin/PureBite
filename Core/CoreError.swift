//
//  CoreError.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/28/24.
//

import Foundation

public enum CoreError: Error {
    case networkError(NetworkError)
    case storageError(StorageError)
    case validationError(ValidationError)
    case unknownError

    // Nested enum for Network Errors
    public enum NetworkError: Error {
        case timeout
        case serverUnreachable
        case invalidResponse(statusCode: Int? = nil)
        case noInternetConnection
        case unauthorized
        case missingAPIKey
        case spoonacularError(Error)
        case decodingError
        case invalidURL

        public var description: String {
            switch self {
            case .timeout: "Timeout"
            case .serverUnreachable: "Server unreachable"
            case .invalidResponse(let code): "Invalid response: \(code ?? 0)"
            case .noInternetConnection: "No internet connection"
            case .unauthorized: "Unauthorized"
            case .missingAPIKey: "Missing API key"
            case .spoonacularError(let error): "Spoonacular error: \(error)"
            case .decodingError: "Decoding error"
            case .invalidURL: "Invalid URL"
            }
        }
    }

    // StorageError and ValidationError can follow a similar pattern if needed
    public enum StorageError: Error {
        case saveFailed
        case readFailed
        case deleteFailed
        case dataCorrupted

        public var description: String {
            switch self {
            case .saveFailed: "Save failed"
            case .readFailed: "Read failed"
            case .deleteFailed: "Delete failed"
            case .dataCorrupted: "Data corrupted"
            }
        }

    }

    public enum ValidationError: Error {
        case invalidInput(field: String)
        case missingField(field: String)

        public var description: String {
            switch self {
            case .invalidInput(field: let field): "Invalid input for field: \(field)"
            case .missingField(field: let field): "Missing field: \(field)"
            }
        }

    }

    public var description: String {
        switch self {
        case .networkError(let error): error.description
        case .storageError(let error): error.description
        case .validationError(let error): error.description
        case .unknownError: "Unknown error"
        }
    }
}
