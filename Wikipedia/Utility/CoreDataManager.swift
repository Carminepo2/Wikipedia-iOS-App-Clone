//
//  CoreDataManager.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 16/12/21.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecentSearchesModel")
        
        container.loadPersistentStores(completionHandler: { _, error in
            _ = error.map { fatalError("Unresolved error \($0)") }
        })
        
        return container
    }()
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    func loadRecentSearches() -> [RecentSearch] {
        let mainContext = CoreDataManager.shared.mainContext
        let fetchRequest: NSFetchRequest<RecentSearch> = RecentSearch.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \RecentSearch.searchedAt, ascending: false)]
        do {
            let results = try mainContext.fetch(fetchRequest)
            return results
        }
        catch {
            debugPrint(error)
            return []
        }
    }
    
    func save() {
        do {
            try mainContext.save()
        } catch {
            debugPrint(error)
        }
    }
    
    func addRecentSearch(query: String, url: String) {
        let context = CoreDataManager.shared.mainContext
        context.perform {
            let entity = RecentSearch.entity()
            let recentSearch = RecentSearch(entity: entity, insertInto: context)
            recentSearch.query = query
            recentSearch.url = url
            recentSearch.searchedAt = Date()
            self.save()
        }
    }
    
    func clearSearches() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "RecentSearch")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try mainContext.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func deleteRecentSearch(_ recentSearch: RecentSearch) {
        mainContext.delete(recentSearch)
        save()
    }

}
