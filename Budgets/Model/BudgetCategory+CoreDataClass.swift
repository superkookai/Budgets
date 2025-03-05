//
//  BudgetCategory+CoreDataClass.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import Foundation
import CoreData

@objc(BudgetCategory)
public class BudgetCategory: NSManagedObject {
    
    //Every time create BudgetCategory will call this func
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
    
    //static functions
    static func transactionsByCategoryRequest(_ budgetCategory: BudgetCategory) -> NSFetchRequest<Transaction> {
        let request = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        request.predicate = NSPredicate(format: "category = %@", budgetCategory)
        return request
    }
    
    static func byId(_ id: NSManagedObjectID) -> BudgetCategory {
        let context = CoreDataManager.shared.viewContext
        guard let budgetCategory = context.object(with: id) as? BudgetCategory else {
            fatalError("ERROR cannot get budget category by id")
        }
        return budgetCategory
    }
    
    static var all: NSFetchRequest<BudgetCategory> {
        let request = BudgetCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }
    
    //Computed Properties
    private var transactionsArray: [Transaction] {
        guard let transactions = transactions else { return [] }
        let allTransactions = (transactions.allObjects as? [Transaction]) ?? []
        return allTransactions.sorted(by: {$0.dateCreated! > $1.dateCreated!})
    }
    
    var transactionsTotal: Double {
        transactionsArray.reduce(into: 0, {$0 += $1.total})
    }
    
    var remainingBudgetTotal: Double {
        self.total - transactionsTotal
    }
    
    var overSpent: Bool {
        remainingBudgetTotal < 0
    }
}
