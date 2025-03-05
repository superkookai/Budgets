//
//  AddBudgetCategoryView.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import SwiftUI

struct AddBudgetCategoryView: View {
    var budgetCategoryToEdit: BudgetCategory? = nil
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var total: Double = 100
    @State private var messages: [String] = []
    
    var isFormValid: Bool {
        messages.removeAll()
        
        if title.isEmpty {
            let message = "Tilte is required"
            messages.append(message)
        }
        
        if total <= 0 {
            let message = "Total must greater than 1"
            messages.append(message)
        }
        
        return messages.isEmpty
    }
    
//    private func save() {
//        if isFormValid {
//            let budgetCategory = BudgetCategory(context: viewContext)
//            budgetCategory.title = self.title
//            budgetCategory.total = self.total
//            
//            do {
//                try viewContext.save()
//                dismiss()
//            } catch {
//                fatalError("ERROR cannot save BudgetCategory: \(error.localizedDescription)")
//            }
//        }
//    }
    
    private func saveOrUpdate() {
        if isFormValid {
            if let budgetCategoryToEdit {
                let budgetToedit = BudgetCategory.byId(budgetCategoryToEdit.objectID)
                budgetToedit.title = self.title
                budgetToedit.total = self.total
            } else {
                let budgetCategory = BudgetCategory(context: viewContext)
                budgetCategory.title = self.title
                budgetCategory.total = self.total
            }
            
            do {
                try viewContext.save()
                dismiss()
            } catch {
                fatalError("ERROR cannot save/edit BudgetCategory: \(error.localizedDescription)")
            }
        }
    }
    
    var hasBudgetToEdit: Bool {
        budgetCategoryToEdit != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                
                Slider(value: $total, in: 0...500, step: 50) {
                    Text("Total")
                } minimumValueLabel: {
                    Text("$0")
                } maximumValueLabel: {
                    Text("$500")
                }
                
                HStack {
                    Text("Budget: ")
                    Text(total as NSNumber, formatter: NumberFormatter.currency)
                }
                .frame(maxWidth: .infinity)
                
                ForEach(messages, id: \.self) { message in
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle(hasBudgetToEdit ? "Edit Budget Category" : "New Budget Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        saveOrUpdate()
                    } label: {
                        Text(hasBudgetToEdit ? "Update" : "Add")
                    }
                }
            }
            .onAppear {
                if let budget = budgetCategoryToEdit {
                    self.title = budget.title!
                    self.total = budget.total
                }
            }
        }
    }
}

#Preview {
    AddBudgetCategoryView()
}
