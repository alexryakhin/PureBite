//
//  CoreError.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/28/24.
//

import Foundation

enum CoreError: Error {
    case networkError(NetworkError)
    case storageError(StorageError)
    case validationError(ValidationError)
    case unknownError

    // Nested enum for Network Errors
    enum NetworkError: Error, LocalizedError {
        case timeout
        case serverUnreachable
        case invalidResponse(statusCode: Int? = nil)
        case noInternetConnection
        case unauthorized
        case missingAPIKey
        case spoonacularError(Error)
        case decodingError
        case invalidURL

        var localizedDescription: String {
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
    enum StorageError: Error, LocalizedError {
        case saveFailed
        case readFailed
        case deleteFailed
        case dataCorrupted

        var localizedDescription: String {
            switch self {
            case .saveFailed: "Save failed"
            case .readFailed: "Read failed"
            case .deleteFailed: "Delete failed"
            case .dataCorrupted: "Data corrupted"
            }
        }

    }

    enum ValidationError: Error, LocalizedError {
        case invalidInput(field: String)
        case missingField(field: String)

        var localizedDescription: String {
            switch self {
            case .invalidInput(field: let field): "Invalid input for field: \(field)"
            case .missingField(field: let field): "Missing field: \(field)"
            }
        }

    }

    var localizedDescription: String {
        switch self {
        case .networkError(let error): error.localizedDescription
        case .storageError(let error): error.localizedDescription
        case .validationError(let error): error.localizedDescription
        case .unknownError: "Unknown error"
        }
    }
}
