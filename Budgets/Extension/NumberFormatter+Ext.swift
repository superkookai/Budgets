//
//  NumberFormatter+Ext.swift
//  Budgets
//
//  Created by Weerawut Chaiyasomboon on 05/03/2568.
//

import Foundation

extension NumberFormatter {
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }
}
