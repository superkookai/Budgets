//
//  BudgetDetailView.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import SwiftUI
import CoreData

struct BudgetDetailView: View {
    let budgetCategory: BudgetCategory
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var title: String = ""
    @State private var total: String = ""
    
    var isFormValid: Bool {
        guard let totalAsDouble = Double(total) else { return false }
        return !title.isEmpty && !total.isEmpty && totalAsDouble > 0
    }
    
    private func saveTransaction() {
        let transaction = Transaction(context: viewContext)
        transaction.title = self.title
        transaction.total = Double(self.total)!
        budgetCategory.addToTransactions(transaction)
        
        do {
            try viewContext.save()
            self.title = ""
            self.total = ""
        } catch {
            fatalError("ERROR cannot save transaction: \(error.localizedDescription)")
        }
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        viewContext.delete(transaction)
        do {
            try viewContext.save()
        } catch {
            fatalError("Error deleting transaction")
        }
    }
    
    //MARK: - View
    var body: some View {
        VStack {
            //Header
            VStack {
                Text(budgetCategory.title ?? "")
                    .font(.largeTitle)
                Text("Budget: \(budgetCategory.total as NSNumber, formatter: NumberFormatter.currency)")
                    .bold()
            }
            //Add Transaction Form
            Form {
                Section {
                    TextField("Title", text: $title)
                    TextField("Total", text: $total)
                    
                    Button {
                        //save transaction
                        saveTransaction()
                    } label: {
                        Text("Add Transaction")
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThickMaterial)
                            .clipShape(.rect(cornerRadius: 8))
                    }
                    .disabled(!isFormValid)
                } header: {
                    Text("Add Transaction")
                }
            }
            
            //Summary of Budget
            BudgetSummaryView(budgetCategory: budgetCategory)
            
            //List of Transactions
            TransactionListView(request: BudgetCategory.transactionsByCategoryRequest(budgetCategory), onDeleteTransaction: deleteTransaction)
            
            Spacer()
        }
    }
}

//#Preview {
//    BudgetDetailView(budgetCategory: BudgetCategory())
//}
