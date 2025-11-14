//
//  WorkoutCard.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 14/11/25.
//
import SwiftUI

struct WorkoutCard: View {
    let title: String
    let duration: String
    let difficulty: String
    let exercises: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            
            HStack(spacing: 16) {
                Label(duration, systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Label(difficulty, systemImage: "chart.bar")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Label("\(exercises) exercises", systemImage: "list.bullet")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}
