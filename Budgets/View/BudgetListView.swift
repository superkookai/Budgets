//
//  BudgetListView.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import SwiftUI

struct BudgetListView: View {
    let budgetCategoryResults: FetchedResults<BudgetCategory>
    let onDeleteBudgetCategory: (BudgetCategory) -> Void
    let onEditBudgetCategory: (BudgetCategory) -> Void
    
    var body: some View {
        List {
            if budgetCategoryResults.isEmpty {
                ContentUnavailableView("No Budget Category Stored", systemImage: "list.dash.header.rectangle")
            } else {
                ForEach(budgetCategoryResults) { budgetCategory in
                    NavigationLink(value: budgetCategory) {
                        VStack {
                            HStack {
                                Text(budgetCategory.title ?? "")
                                Spacer()
                                Text(budgetCategory.total as NSNumber, formatter: NumberFormatter.currency)
                            }
                            Text("\(budgetCategory.overSpent ? "Overspent" : "Remaining") \(Text(budgetCategory.remainingBudgetTotal as NSNumber, formatter: NumberFormatter.currency))")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .fontWeight(.bold)
                                .foregroundStyle(budgetCategory.overSpent ? .red : .green)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                onDeleteBudgetCategory(budgetCategory)
                            } label: {
                                Image(systemName: "trash")
                            }
                            
                            Button {
                                onEditBudgetCategory(budgetCategory)
                            } label: {
                                Image(systemName: "pencil")
                            }

                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: BudgetCategory.self) { budgetCategory in
            BudgetDetailView(budgetCategory: budgetCategory)
        }
    }
}


//                .onDelete { indexSet in
//                    indexSet.map({budgetCategoryResults[$0]}).forEach(onDeleteBudgetCategory)
//                }
