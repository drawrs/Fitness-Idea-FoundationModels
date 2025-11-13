//
//  Equipment.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 13/11/25.
//


import SwiftUI

struct Equipment: Identifiable, Hashable {
    let id: String
    let name: String
    let iconName: String
    let color: Color
    let category: EquipmentCategory

    init(name: String, iconName: String, color: Color, category: EquipmentCategory) {
        self.name = name
        self.iconName = iconName
        self.color = color
        self.category = category
        self.id = "\(name.lowercased())-\(category.rawValue.lowercased())"
    }

    static func == (lhs: Equipment, rhs: Equipment) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}