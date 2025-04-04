//
//  FavoritesService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/25/24.
//

import CoreData
import Combine
import Core
import Shared

public protocol FavoritesServiceInterface {
    var favoritesPublisher: AnyPublisher<[Recipe], CoreError> { get }

    func save(recipe: Recipe) throws(CoreError)
    func remove(recipeWithId: Int) throws(CoreError)
    func isFavorite(recipeWithId: Int) throws(CoreError) -> Bool
    func fetchAllFavorites() throws(CoreError) -> [Recipe]
    func fetchRecipeById(_ id: Int) throws(CoreError) -> Recipe
}

public class FavoritesService: FavoritesServiceInterface {
    private let coreDataService: CoreDataServiceInterface
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let favoritesSubject = CurrentValueSubject<[Recipe], CoreError>([])

    public var favoritesPublisher: AnyPublisher<[Recipe], CoreError> {
        return favoritesSubject.eraseToAnyPublisher()
    }

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        // Initial load of favorite recipes
        loadFavorites()
    }

    private func loadFavorites() {
        do {
            try fetchAllFavorites()
        } catch {
            favoritesSubject.send(completion: .failure(error))
        }
    }

    public func save(recipe: Recipe) throws(CoreError) {
        let context = coreDataService.context
        let favorite = RecipeCDModel(context: context)
        if let aggregateLikes = recipe.aggregateLikes {
            favorite.aggregateLikes = Int32(aggregateLikes)
        }
        if let healthScore = recipe.healthScore {
            favorite.healthScore = Int32(healthScore)
        }
        favorite.id = Int64(recipe.id)
        favorite.image = recipe.image?.absoluteString
        if let ingredients = recipe.extendedIngredients {
            favorite.ingredients = try? encoder.encode(ingredients)
        }
        favorite.instructions = recipe.instructions
        if let mealTypes = recipe.dishTypes, !mealTypes.isEmpty {
            favorite.mealTypes = try? encoder.encode(mealTypes)
        }
        if let nutrition = recipe.nutrition {
            favorite.nutrition = try? encoder.encode(nutrition)
        }
        if let occasions = recipe.occasions, !occasions.isEmpty {
            favorite.occasions = try? encoder.encode(occasions)
        }
        if let readyInMinutes = recipe.readyInMinutes {
            favorite.readyInMinutes = Int32(readyInMinutes)
        }
        if let servings = recipe.servings {
            favorite.servings = Int32(servings)
        }
        favorite.sourceUrl = recipe.sourceURL
        favorite.sourceName = recipe.sourceName
        if let spoonacularScore = recipe.spoonacularScore {
            favorite.spoonacularScore = spoonacularScore
        }
        favorite.summary = recipe.summary
        favorite.sustainable = recipe.sustainable ?? false
        if let taste = recipe.taste {
            favorite.taste = try? encoder.encode(taste)
        }
        favorite.timestamp = Date()
        favorite.title = recipe.title
        favorite.vegan = recipe.vegan ?? false
        favorite.vegetarian = recipe.vegetarian ?? false
        favorite.veryHealthy = recipe.veryHealthy ?? false
        favorite.veryPopular = recipe.veryPopular ?? false

        do {
            try coreDataService.saveContext()
            // Reload favorites and publish the updated list
            loadFavorites()
        } catch {
            throw error
        }
    }

    public func remove(recipeWithId id: Int) throws(CoreError) {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<RecipeCDModel> = RecipeCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            if let favorite = results.first {
                context.delete(favorite)
                try coreDataService.saveContext()
                // Reload favorites and publish the updated list
                loadFavorites()
            }
        } catch {
            throw CoreError.storageError(.saveFailed)
        }
    }

    public func isFavorite(recipeWithId id: Int) throws(CoreError) -> Bool {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<RecipeCDModel> = RecipeCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            throw CoreError.storageError(.readFailed)
        }
    }

    @discardableResult
    public func fetchAllFavorites() throws(CoreError) -> [Recipe] {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<RecipeCDModel> = RecipeCDModel.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]

        do {
            let results = try context.fetch(fetchRequest)
            let returnValue = results.compactMap(mapRecipe(from:))
            favoritesSubject.send(returnValue)
            return returnValue
        } catch {
            throw CoreError.storageError(.readFailed)
        }
    }

    public func fetchRecipeById(_ id: Int) throws(CoreError) -> Recipe {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<RecipeCDModel> = RecipeCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        if let favorite = try? context.fetch(fetchRequest).first {
            return mapRecipe(from: favorite)
        } else {
            throw CoreError.storageError(.readFailed)
        }
    }

    private func mapRecipe(from model: RecipeCDModel) -> Recipe {
        Recipe(
            id: Int(model.id),
            title: model.title ?? .empty,
            aggregateLikes: Int(model.aggregateLikes),
            dishTypes: try? decoder.decode([String].self, from: model.mealTypes ?? Data()),
            extendedIngredients: try? decoder.decode([ExtendedIngredient].self, from: model.ingredients ?? Data()),
            healthScore: Int(model.healthScore),
            image: URL(string: model.image),
            instructions: model.instructions,
            nutrition: try? decoder.decode(Nutrition.self, from: model.nutrition ?? Data()),
            occasions: try? decoder.decode([String].self, from: model.occasions ?? Data()),
            readyInMinutes: Int(model.readyInMinutes),
            servings: Int(model.servings),
            sourceName: model.sourceName,
            sourceURL: model.sourceUrl,
            spoonacularScore: model.spoonacularScore,
            summary: model.summary,
            taste: try? decoder.decode(Taste.self, from: model.taste ?? Data()),
            sustainable: model.sustainable,
            vegan: model.vegan,
            vegetarian: model.vegetarian,
            veryHealthy: model.veryHealthy,
            veryPopular: model.veryPopular
        )
    }
}

#if DEBUG
public class FavoritesServiceMock: FavoritesServiceInterface {
    private let favoritesSubject = CurrentValueSubject<[Recipe], CoreError>([])

    public var favoritesPublisher: AnyPublisher<[Recipe], CoreError> {
        return favoritesSubject.eraseToAnyPublisher()
    }

    private var recipes: [Recipe] = []

    public init(recipes: [Recipe] = []) {
        self.recipes = recipes
    }

    public func save(recipe: Recipe) {
        recipes.append(recipe)
    }

    public func remove(recipeWithId id: Int) {
        recipes.removeAll {
            id == $0.id
        }
    }

    public func isFavorite(recipeWithId id: Int) -> Bool {
        recipes.contains {
            id == $0.id
        }
    }

    public func fetchAllFavorites() throws(CoreError) -> [Recipe] {
        recipes
    }

    public func fetchRecipeById(_ id: Int) throws(CoreError) -> Recipe {
        Recipe(id: 0, title: "Title")
    }
}
#endif
