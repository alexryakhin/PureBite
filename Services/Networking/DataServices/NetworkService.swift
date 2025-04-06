//
//  NetworkService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation
import Core

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
        responseHeaders: inout [String: String?],
        errorType: E.Type
    ) async throws(CoreError) -> T
}

public class NetworkService: NetworkServiceInterface {

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
        responseHeaders: inout [String: String?],
        errorType: E.Type
    ) async throws(CoreError) -> T {

        #if DEBUG
        if featureToggleService.featureToggles.value.isEnabled(.mock_data),
           let decodedMockResponse: T = Bundle.main.decode(endpoint.mockFileName) {
            try? await Task.sleep(nanoseconds: 500_000_000)
            return decodedMockResponse
        }
        #endif

        guard let url = endpoint.url(apiKey: apiKey) else {
            throw CoreError.networkError(.invalidURL)
        }

        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 15)

        guard let (data, response) = try? await URLSession.shared.data(for: request) else {
            throw CoreError.networkError(.noInternetConnection)
        }

        #if DEBUG
        if featureToggleService.featureToggles.value.isEnabled(.print_json_responses), let str = data.prettyPrintedJSONString {
            print("DEBUG RequestURL \(url.absoluteString), data: \(str)")
        }
        #endif

        // Cast response to HTTPURLResponse to access header fields
        if let httpResponse = response as? HTTPURLResponse {
            let responseKeys = httpResponse.allHeaderFields.keys.map({ String(describing: $0) })
            for key in responseKeys {
                responseHeaders[key] = httpResponse.value(forHTTPHeaderField: key)
            }
        }

        if let error = errorParser.parseResponseError(response, data: data, type: errorType) {
            throw error
        }

        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw CoreError.networkError(.decodingError)
        }
    }
}

#if DEBUG
public class NetworkServiceMock: NetworkServiceInterface {

    public init() {}

    public func request<T: Decodable, E: Error & Decodable>(
        for endpoint: APIEndpoint,
        apiKey: String,
        responseHeaders: inout [String: String?],
        errorType: E.Type
    ) async throws(CoreError) -> T {
        if let decodedMockResponse: T = Bundle.main.decode(endpoint.mockFileName) {
            try? await Task.sleep(nanoseconds: 500_000_000)
            return decodedMockResponse
        } else {
            throw CoreError.networkError(.invalidResponse())
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
