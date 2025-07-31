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

@MainActor
public final class SavedRecipesService: ObservableObject {
    public static let shared = SavedRecipesService()
    
    @Published public private(set) var savedRecipes: [Recipe] = []
    @Published public private(set) var error: Error?
    
    public let errorPublisher = PassthroughSubject<Error, Never>()
    
    private let coreDataService: CoreDataService
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.coreDataService = CoreDataService.shared
        setupBindings()
        fetchAllFavorites()
    }
    
    public func save(recipe: Recipe) {
        let context = coreDataService.context
        let newCDRecipe = CDRecipe(context: context)
        newCDRecipe.id = recipe.id.int64
        newCDRecipe.title = recipe.title
        newCDRecipe.summary = recipe.summary
        newCDRecipe.instructions = recipe.instructions
        newCDRecipe.dateSaved = recipe.dateSaved
        newCDRecipe.cuisines = recipe.cuisines.toData
        newCDRecipe.diets = recipe.diets.toData
        newCDRecipe.mealTypes = recipe.mealTypes.toData
        newCDRecipe.occasions = recipe.occasions.toData
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
            newCDIngredient.recipe = newCDRecipe
            newCDRecipe.addToIngredients(newCDIngredient)
        }

        save()
    }

    public func remove(recipeWithId id: Int) {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            if let cdRecipe = try context.fetch(fetchRequest).first {
                context.delete(cdRecipe)
            }
        } catch {
            self.error = CoreError.storageError(.deleteFailed)
            errorPublisher.send(CoreError.storageError(.deleteFailed))
        }
        save()
    }

    public func isFavorite(recipeWithId id: Int) -> Bool {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            return results.isNotEmpty
        } catch {
            self.error = CoreError.storageError(.readFailed)
            errorPublisher.send(CoreError.storageError(.readFailed))
            return false
        }
    }

    @discardableResult
    public func fetchAllFavorites() -> [Recipe] {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateSaved", ascending: false)]

        do {
            let results = try context.fetch(fetchRequest)
            let returnValue = results.compactMap(\.coreModel)
            savedRecipes = returnValue
            return returnValue
        } catch {
            self.error = CoreError.storageError(.readFailed)
            errorPublisher.send(CoreError.storageError(.readFailed))
            return []
        }
    }

    public func fetchRecipeById(_ id: Int) -> Recipe? {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<CDRecipe> = CDRecipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        return try? context.fetch(fetchRequest).first?.coreModel
    }

    private func setupBindings() {
        coreDataService.dataUpdatedPublisher
            .sink { [weak self] _ in
                self?.fetchAllFavorites()
            }
            .store(in: &cancellables)
    }

    private func save() {
        do {
            try coreDataService.saveContext()
        } catch {
            self.error = error
            errorPublisher.send(error)
        }
    }
}
