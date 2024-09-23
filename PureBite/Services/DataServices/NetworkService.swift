//
//  NetworkService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public protocol APIEndpoint {
    func url(apiKey: String) -> URL?

    #if DEBUG
    var mockFileName: String { get }
    #endif
}

public protocol NetworkServiceInterface {
    func request<T: Decodable, E: Error & Decodable>(
        for endpoint: APIEndpoint,
        apiKey: String,
        errorType: E.Type
    ) async throws -> T
}

public final class NetworkService: NetworkServiceInterface {

    private let featureToggleService: FeatureToggleServiceInterface
    private let errorParser: ErrorParser

    public init(
        featureToggleService: FeatureToggleServiceInterface,
        errorParser: ErrorParser
    ) {
        self.featureToggleService = featureToggleService
        self.errorParser = errorParser
    }

    public func request<T: Decodable, E: Error & Decodable>(
        for endpoint: APIEndpoint,
        apiKey: String,
        errorType: E.Type
    ) async throws -> T {

        #if DEBUG
        if featureToggleService.featureToggles.value.isEnabled(.mock_data),
           let decodedMockResponse: T = Bundle.main.decode(endpoint.mockFileName) {
            try await Task.sleep(nanoseconds: 500_000_000)
            return decodedMockResponse
        }
        #endif

        guard let url = endpoint.url(apiKey: apiKey) else {
            throw DefaultError.network(NetworkError.invalidURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        #if DEBUG
        if let str = data.prettyPrintedJSONString {
            print("DEBUG RequestURL \(url.absoluteString), data: \(str)")
        }
        #endif

        if let error = errorParser.parseResponseError(response, data: data, type: errorType) {
            throw error
        }

        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}

#if DEBUG
public struct NetworkServiceMock: NetworkServiceInterface {

    public init() {}

    public func request<T: Decodable, E: Error & Decodable>(
        for endpoint: APIEndpoint,
        apiKey: String,
        errorType: E.Type
    ) async throws -> T {
        if let decodedMockResponse: T = Bundle.main.decode(endpoint.mockFileName) {
            try await Task.sleep(nanoseconds: 500_000_000)
            return decodedMockResponse
        } else {
            throw DefaultError.network(NetworkError.invalidResponse)
        }
    }
}
#endif

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case spoonacularError(Error)
    case invalidResponseWithStatusCode(Int)
}
