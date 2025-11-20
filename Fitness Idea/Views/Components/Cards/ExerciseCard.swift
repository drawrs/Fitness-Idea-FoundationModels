//
//  ExerciseCard.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 14/11/25.
//
import SwiftUI
import SafariServices

struct ExerciseCard: View {
    let exercise: ExerciseRecommendation
    @State private var showingSafariView = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(exercise.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Button(action: {
                    showingSafariView = true
                }) {
                    Image(systemName: "info.circle")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 16) {
                Label("\(exercise.sets) sets", systemImage: "square.stack.3d.up.fill")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Label("\(exercise.reps) reps", systemImage: "repeat")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Label(exercise.duration, systemImage: "timer")
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
        .sheet(isPresented: $showingSafariView) {
            if let url = URL(string: exercise.googleSearchURL) {
                SafariView(url: url)
                    .ignoresSafeArea()
            }
        }
    }
}

