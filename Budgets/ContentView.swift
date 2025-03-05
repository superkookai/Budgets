//
//  ContentView.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import SwiftUI

enum SheetAction: Identifiable {
    case add
    case edit(BudgetCategory)
    
    var id: Int {
        switch self {
            case .add:
                return 1
            case .edit(_):
                return 2
        }
    }
}

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    //    @FetchRequest(sortDescriptors: []) private var budgetCategoryResults: FetchedResults<BudgetCategory>
    @FetchRequest(fetchRequest: BudgetCategory.all) var budgetCategoryResults
    
    @State private var sheetAction: SheetAction?
    
    var grandTotal: Double {
        budgetCategoryResults.reduce(into: 0) { partialResult, budgetCategory in
            partialResult += budgetCategory.total
        }
    }
    
    private func deleteBudgetCategory(_ category: BudgetCategory) {
        viewContext.delete(category)
        do {
            try viewContext.save()
        } catch {
            fatalError("Error deleting budget category")
        }
    }
    
    private func editBudgetCategory(_ category: BudgetCategory) {
        sheetAction = .edit(category)
    }
    
    //MARK: - View
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Total Budget:")
                    Text(grandTotal as NSNumber, formatter: NumberFormatter.currency)
                    Spacer()
                }
                .padding(.horizontal)
                .fontWeight(.bold)
                
                BudgetListView(budgetCategoryResults: budgetCategoryResults, onDeleteBudgetCategory: deleteBudgetCategory, onEditBudgetCategory: editBudgetCategory)
            }
            .navigationTitle("Budget Category")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sheetAction = .add
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
            .sheet(item: $sheetAction) { sheetAction in
                switch sheetAction {
                case .add:
                    AddBudgetCategoryView()
                        .presentationDetents([.medium])
                case .edit(let bugetCategory):
                    AddBudgetCategoryView(budgetCategoryToEdit: bugetCategory)
                        .presentationDetents([.medium])
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
}
