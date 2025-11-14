//
//  ExerciseCard.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 14/11/25.
//
import SwiftUI

struct ExerciseCard: View {
    let exercise: ExerciseRecommendation.PartiallyGenerated

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(exercise.name ?? "...")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)

            HStack(spacing: 16) {
                Label("\(exercise.sets ?? 0) sets", systemImage: "square.stack.3d.up.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Label("\(exercise.reps ?? 0) reps", systemImage: "repeat")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Label(exercise.duration ?? "...", systemImage: "timer")
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
