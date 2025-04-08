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
    private let favoritesSubject = CurrentValueSubject<[Recipe], CoreError>([])

    public var favoritesPublisher: AnyPublisher<[Recipe], CoreError> {
        return favoritesSubject.eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
        setupBindings()
        loadFavorites()
    }

    public func save(recipe: Recipe) throws(CoreError) {
        let context = coreDataService.context
        let newCDRecipe = CDRecipe(context: context)
        newCDRecipe.id = recipe.id.int64
        newCDRecipe.title = recipe.title
        newCDRecipe.summary = recipe.summary
        newCDRecipe.instructions = recipe.instructions
        newCDRecipe.dateSaved = recipe.dateSaved
        newCDRecipe.cuisines = recipe.cuisines.toString
        newCDRecipe.diets = recipe.diets.toString
        newCDRecipe.mealTypes = recipe.mealTypes.toString
        newCDRecipe.occasions = recipe.occasions.toString
        newCDRecipe.score = recipe.score
        newCDRecipe.servings = recipe.servings
        newCDRecipe.likes = recipe.likes.int64
        newCDRecipe.cookingMinutes = recipe.cookingMinutes ?? .zero
        newCDRecipe.healthScore = recipe.healthScore
        newCDRecipe.preparationMinutes = recipe.preparationMinutes ?? .zero
        newCDRecipe.pricePerServing = recipe.pricePerServing
        newCDRecipe.readyInMinutes = recipe.readyInMinutes
        newCDRecipe.isCheap = recipe.isCheap
        newCDRecipe.isVegan = recipe.isVegan
        newCDRecipe.isSustainable = recipe.isSustainable
        newCDRecipe.isVegetarian = recipe.isVegetarian
        newCDRecipe.isVeryHealthy = recipe.isVeryHealthy
        newCDRecipe.isVeryPopular = recipe.isVeryPopular
        newCDRecipe.isGlutenFree = recipe.isGlutenFree
        newCDRecipe.isDairyFree = recipe.isDairyFree

        for ingredient in recipe.ingredients {
            let newCDIngredient = CDIngredient(context: context)
            newCDIngredient.id = ingredient.id.int64
            newCDIngredient.amount = ingredient.amount
            newCDIngredient.imageUrlPath = ingredient.imageUrlPath
            newCDIngredient.unit = ingredient.unit
            newCDIngredient.name = ingredient.name
            newCDIngredient.aisle = ingredient.aisle

            newCDIngredient.addToRecipes(newCDRecipe)
            newCDRecipe.addToIngredients(newCDIngredient)
        }

        try coreDataService.saveContext()
    }

    public func remove(recipeWithId id: Int) throws(CoreError) {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            if let cdRecipe = try context.fetch(fetchRequest).first {
                context.delete(cdRecipe)
            }
        } catch {
            throw CoreError.storageError(.deleteFailed)
        }
        try coreDataService.saveContext()
    }

    public func isFavorite(recipeWithId id: Int) throws(CoreError) -> Bool {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            return results.isNotEmpty
        } catch {
            throw CoreError.storageError(.readFailed)
        }
    }

    @discardableResult
    public func fetchAllFavorites() throws(CoreError) -> [Recipe] {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateSaved", ascending: false)]

        do {
            let results = try context.fetch(fetchRequest)
            let returnValue = results.compactMap(\.coreModel)
            favoritesSubject.send(returnValue)
            return returnValue
        } catch {
            throw CoreError.storageError(.readFailed)
        }
    }

    public func fetchRecipeById(_ id: Int) throws(CoreError) -> Recipe {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        if let recipe = try? context.fetch(fetchRequest).first?.coreModel {
            return recipe
        } else {
            throw CoreError.storageError(.readFailed)
        }
    }

    private func setupBindings() {
        coreDataService.dataUpdatedPublisher
            .sink { [weak self] _ in
                self?.loadFavorites()
            }
            .store(in: &cancellables)
    }

    private func loadFavorites() {
        do {
            try fetchAllFavorites()
        } catch {
            favoritesSubject.send(completion: .failure(error))
        }
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
        Recipe.mock
    }
}
#endif
