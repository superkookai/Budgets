//
//  TransactionListView.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import SwiftUI
import CoreData

struct TransactionListView: View {
    @FetchRequest var transactions: FetchedResults<Transaction>
    let onDeleteTransaction: (Transaction) -> Void
    
    init(request: NSFetchRequest<Transaction>, onDeleteTransaction: @escaping (Transaction) -> Void) {
        _transactions = FetchRequest(fetchRequest: request)
        self.onDeleteTransaction = onDeleteTransaction
    }
    
    var body: some View {
        VStack {
            if transactions.isEmpty {
                Text("No Transactions")
            } else {
                List(transactions) { transaction in
                    HStack {
                        Text(transaction.title ?? "")
                            .bold()
                        Spacer()
                        Text(transaction.total as NSNumber, formatter: NumberFormatter.currency)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            onDeleteTransaction(transaction)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
                .listStyle(.plain)
            }
            Spacer()
        }
    }
}

//#Preview {
//    TransactionListView()
//}
