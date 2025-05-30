//
//  ErrorParser.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/23/24.
//
import Foundation
import Core
import Shared

public struct ErrorParser {

    public init() {}

    public func parseResponseError<E: Error & Decodable>(_ response: URLResponse?, data: Data?, type: E.Type) -> CoreError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return CoreError.networkError(.invalidResponse())
        }

        // Parse specific error based on response data
        if let data = data, let serverError = try? JSONDecoder().decode(E.self, from: data) {
            return CoreError.networkError(.spoonacularError(serverError))
        }

        if !(200...299).contains(httpResponse.statusCode) {
            return CoreError.networkError(.invalidResponse(statusCode: httpResponse.statusCode))
        }

        return nil
    }

    public func parseDecodingError(_ error: Error) -> CoreError {
        fault("Decoding error: \(error)")
        return CoreError.networkError(.decodingError)
    }
}
