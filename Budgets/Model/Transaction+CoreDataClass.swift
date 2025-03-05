//
//  Transaction+CoreDataClass.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    public override func awakeFromInsert() {
        self.dateCreated = Date()
    }
}
