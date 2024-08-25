//
//  FavoritesService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/25/24.
//

import CoreData

public protocol FavoritesServiceInterface {
    func save(recipe: Recipe) throws
    func remove(recipeWithId: Int) throws
    func isFavorite(recipeWithId: Int) throws -> Bool
}

public class FavoritesService: FavoritesServiceInterface {
    private let coreDataService: CoreDataServiceInterface

    public init(coreDataService: CoreDataServiceInterface) {
        self.coreDataService = coreDataService
    }
    
    public func save(recipe: Recipe) throws {
        let context = coreDataService.context
        let favorite = RecipeCDModel(context: context)
        favorite.id = Int64(recipe.id)
        favorite.title = recipe.title

        do {
            try coreDataService.saveContext()
        } catch {
            throw error
        }
    }
    
    public func remove(recipeWithId id: Int) throws {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<RecipeCDModel> = RecipeCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            if let favorite = results.first {
                context.delete(favorite)
                try coreDataService.saveContext()
            }
        } catch {
            throw DefaultError(.coreDataError("Failed to delete recipe: \(error.localizedDescription)"))
        }
    }
    
    public func isFavorite(recipeWithId id: Int) throws -> Bool {
        let context = coreDataService.context
        let fetchRequest: NSFetchRequest<RecipeCDModel> = RecipeCDModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)

        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            throw DefaultError(.coreDataError("Failed to fetch favorite status: \(error.localizedDescription)"))
        }
    }
}

#if DEBUG
public class FavoritesServiceMock: FavoritesServiceInterface {
    private var recipes: [Recipe] = []

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
}
#endif
