//
//  NetworkService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 6/16/24.
//

import Foundation

public protocol APIEndpoint {
    var url: URL? { get }

    #if DEBUG
    var mockFileName: String { get }
    #endif
}

public protocol NetworkServiceInterface {
    func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T
}

public final class NetworkService: NetworkServiceInterface {

    private let featureToggleService: FeatureToggleServiceInterface

    public init(
        featureToggleService: FeatureToggleServiceInterface
    ) {
        self.featureToggleService = featureToggleService
    }

    public func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T {

        #if DEBUG
        if featureToggleService.featureToggles.value.isEnabled(.mock_data),
           let decodedMockResponse: T = Bundle.main.decode(endpoint.mockFileName) {
            try await Task.sleep(nanoseconds: 500_000_000)
            return decodedMockResponse
        }
        #endif

        guard let url = endpoint.url else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        #if DEBUG
        if let str = data.prettyPrintedJSONString {
            print("DEBUG RequestURL \(url.absoluteString), data: \(str)")
        }
        #endif

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
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

    public func request<T: Decodable>(_ endpoint: APIEndpoint, responseType: T.Type) async throws -> T {
        if let decodedMockResponse: T = Bundle.main.decode(endpoint.mockFileName) {
            try await Task.sleep(nanoseconds: 500_000_000)
            return decodedMockResponse
        } else {
            throw NetworkError.invalidResponse
        }
    }
}
#endif

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
}
