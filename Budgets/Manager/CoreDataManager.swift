//
//  CoreDataManager.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private var persistenceContainer: NSPersistentContainer
    
    private init() {
        persistenceContainer = NSPersistentContainer(name: "BudgetModel")
        persistenceContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("ERROR unable to intitialize CoreData stack: \(error.localizedDescription)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistenceContainer.viewContext
    }
}
