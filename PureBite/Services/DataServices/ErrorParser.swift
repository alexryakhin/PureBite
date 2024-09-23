//
//  ErrorParser.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 9/23/24.
//
import Foundation

public struct ErrorParser {

    public func parseResponseError<E: Error & Decodable>(_ response: URLResponse?, data: Data?, type: E.Type) -> DefaultError? {
        guard let httpResponse = response as? HTTPURLResponse else {
            return DefaultError.network(NetworkError.invalidResponse)
        }

        // Parse specific error based on response data
        if let data = data, let serverError = try? JSONDecoder().decode(E.self, from: data) {
            return DefaultError.network(NetworkError.spoonacularError(serverError))
        }

        if !(200...299).contains(httpResponse.statusCode) {
            return DefaultError.network(NetworkError.invalidResponseWithStatusCode(httpResponse.statusCode))
        }

        return nil
    }

    public func parseDecodingError(_ error: Error) -> DefaultError {
        return DefaultError.network(NetworkError.decodingError(error))
    }
}
