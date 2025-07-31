//
//  FavoritesService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/25/24.
//

import CoreData
import Combine

@MainActor
final class SavedRecipesService: ObservableObject {
    static let shared = SavedRecipesService()
    
    @Published private(set) var savedRecipes: [Recipe] = []
    @Published private(set) var error: Error?
    
    let errorPublisher = PassthroughSubject<Error, Never>()
    
    private let coreDataService: CoreDataService
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        self.coreDataService = CoreDataService.shared
        setupBindings()
        fetchAllFavorites()
    }
    
    func save(recipe: Recipe) {
        let context = coreDataService.context
        
        // Create the CDRecipe using the new optimized method
        let newCDRecipe = CDRecipe.create(from: recipe, in: context)

        // Create ingredients
        for ingredient in recipe.ingredients {
            let newCDIngredient = CDIngredient(context: context)
            newCDIngredient.id = ingredient.id.int64
            newCDIngredient.amount = ingredient.amount
            newCDIngredient.imageUrlPath = ingredient.imageUrlPath
            newCDIngredient.unit = ingredient.unit
            newCDIngredient.name = ingredient.name
            newCDIngredient.aisle = ingredient.aisle
            newCDIngredient.consistency = ingredient.consistency
            newCDIngredient.measures = ingredient.measuresData
            newCDIngredient.possibleUnits = try? JSONEncoder().encode(ingredient.measures?.metric?.unitShort.map { [$0] } ?? [])
            newCDIngredient.recipe = newCDRecipe
            newCDRecipe.addToIngredients(newCDIngredient)
        }

        save()
    }

    func remove(recipeWithId id: Int) {
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

    func isFavorite(recipeWithId id: Int) -> Bool {
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
    func fetchAllFavorites() -> [Recipe] {
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

    func fetchRecipeById(_ id: Int) -> Recipe? {
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
