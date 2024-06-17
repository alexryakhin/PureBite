import Foundation

public extension Sequence {

    @available(iOS 13.0.0, *)
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values: [T] = []

        for element in self {
            let value = try await transform(element)
            values.append(value)
        }

        return values
    }

    @available(iOS 13.0.0, *)
    func asyncCompactMap<T>(
        _ transform: (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values: [T] = []

        for element in self {
            if let value = try await transform(element) {
                values.append(value)
            }
        }

        return values
    }
}
