//
//  BodyPartCard.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 13/11/25.
//
import SwiftUI

struct BodyPartCard: View {
    let bodyPart: BodyPart
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(bodyPart.color.opacity(isSelected ? 0.3 : 0.1))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: bodyPart.iconName)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundStyle(isSelected ? bodyPart.color : .secondary)
                }
                
                Text(bodyPart.name)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 130)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.systemBackground))
                    .stroke(
                        isSelected ? bodyPart.color : Color(.systemGray4),
                        lineWidth: isSelected ? 2.5 : 1
                    )
                    .shadow(
                        color: isSelected ? bodyPart.color.opacity(0.2) : .clear,
                        radius: isSelected ? 8 : 0,
                        x: 0,
                        y: isSelected ? 4 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
