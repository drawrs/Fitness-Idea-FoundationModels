//
//  BodyPart.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 13/11/25.
//

import SwiftUI

struct BodyPart: Identifiable, Hashable {
    let id: String
    let name: String
    let iconName: String
    let color: Color

    init(name: String, iconName: String, color: Color) {
        self.id = name.lowercased()
        self.name = name
        self.iconName = iconName
        self.color = color
    }

    static func == (lhs: BodyPart, rhs: BodyPart) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
