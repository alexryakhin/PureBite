import Foundation
import Core
import CoreUserInterface
import Shared
import Services

public struct MainPageRecipeCategory: Identifiable {
    public let id: String = UUID().uuidString
    public let kind: Kind
    public let recipes: [RecipeShortInfo]

    public init(kind: Kind, recipes: [RecipeShortInfo]) {
        self.kind = kind
        self.recipes = recipes
    }

    public enum Kind: CaseIterable {
        case recommended
        case highProtein
        case quickAndEasy
        case global
        case keto

        var title: String {
            switch self {
            case .recommended: "Recommended for you"
            case .highProtein: "High Protein"
            case .quickAndEasy: "Quick & Easy"
            case .global: "Global Cuisines"
            case .keto: "Keto Recipes"
            }
        }

        var searchParams: SearchRecipesParams {
            switch self {
            case .recommended: return .init(diet: [.whole30], maxSugar: 1, number: 10)
            case .highProtein: return .init(minProtein: 65, number: 10)
            case .quickAndEasy: return .init(maxReadyTime: 15, number: 10)
            case .global: return .init(cuisines: [.italian, .chinese, .mexican], number: 10)
            case .keto: return .init(maxCarbs: 10, number: 10)
            }
        }
    }
}

public struct RecipeCategoryAsyncSequence: AsyncSequence {
    public typealias Element = MainPageRecipeCategory.Kind
    public typealias AsyncIterator = RecipeCategoryAsyncIterator

    private let categories: [MainPageRecipeCategory.Kind]

    public init(categories: [MainPageRecipeCategory.Kind]) {
        self.categories = categories
    }

    public struct RecipeCategoryAsyncIterator: AsyncIteratorProtocol {
        private var currentIndex = 0
        private let categories: [MainPageRecipeCategory.Kind]

        init(categories: [MainPageRecipeCategory.Kind]) {
            self.categories = categories
        }

        public mutating func next() async -> MainPageRecipeCategory.Kind? {
            guard currentIndex < categories.count else { return nil }
            defer { currentIndex += 1 }
            return categories[currentIndex]
        }
    }

    public func makeAsyncIterator() -> RecipeCategoryAsyncIterator {
        return RecipeCategoryAsyncIterator(categories: categories)
    }
}

extension Array: AsyncSequence where Element == MainPageRecipeCategory.Kind {
    public typealias AsyncIterator = RecipeCategoryAsyncSequence.AsyncIterator

    public func makeAsyncIterator() -> RecipeCategoryAsyncSequence.AsyncIterator {
        return RecipeCategoryAsyncSequence(categories: self).makeAsyncIterator()
    }
}

