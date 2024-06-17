import Foundation

public protocol Searchable: Identifiable, Equatable {
    var name: String { get }
}
