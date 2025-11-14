//
//  WorkoutRecommendationView.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 13/11/25.
//

import SwiftUI

struct WorkoutRecommendationView: View {
    @StateObject private var viewModel: WorkoutRecommendationViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(selectedBodyParts: Set<BodyPart>, selectedEquipment: Set<Equipment>, onStartOver: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: WorkoutRecommendationViewModel(selectedBodyParts: selectedBodyParts,
                                                                              selectedEquipment: selectedEquipment,
                                                                              onStartOver: onStartOver))
    }
    
    var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Scrollable content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Header with back to start button
                            VStack(spacing: 12) {
                                
                                Text("Workout Recommendations")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.primary)
                                    .tracking(-0.5)
                                    .multilineTextAlignment(.center)
                                
                                Text("Based on your selections, here are the perfect workouts for you")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                            
                            // Selected Body Parts Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Target Muscles")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(viewModel.selectedBodyParts), id: \.id) { bodyPart in
                                            HStack(spacing: 8) {
                                                Image(systemName: bodyPart.iconName)
                                                    .font(.caption)
                                                    .foregroundStyle(bodyPart.color)
                                                
                                                Text(bodyPart.name)
                                                    .font(.caption)
                                                    .fontWeight(.medium)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(bodyPart.color.opacity(0.1))
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            // Selected Equipment Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Available Equipment")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(Array(viewModel.selectedEquipment), id: \.id) { equipment in
                                            HStack(spacing: 8) {
                                                Image(systemName: equipment.iconName)
                                                    .font(.caption)
                                                    .foregroundStyle(equipment.color)
                                                
                                                Text(equipment.name)
                                                    .font(.caption)
                                                    .fontWeight(.medium)
                                            }
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(equipment.color.opacity(0.1))
                                            )
                                        }
                                    }
                                    .padding(.horizontal, 20)
                                }
                            }
                            
                            // Recommended Exercises
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Recommended Exercises")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 20)

                                VStack(spacing: 12) {
                                    ForEach(viewModel.recommendedExercises) { exercise in
                                        ExerciseCard(exercise: exercise)
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Bottom padding
                            Spacer(minLength: 120)
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                    // Fixed bottom action section
                    VStack(spacing: 16) {
                        Button(action: {
                            // Start the selected workout
                            viewModel.startWorkout()
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "play.fill")
                                    .font(.headline)
                                Text("Start Workout")
                                    .fontWeight(.semibold)
                            }
                            .font(.title3)
                            .foregroundStyle(.white)
                            .padding(.vertical, 18)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 16))
                        }
                        .padding(.horizontal, 20)
                        
                        Button(action: {
                            viewModel.startOver()
                            withAnimation { dismiss() }
                        }) {
                            Text("Start Over")
                                .font(.callout)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.top, 16)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 20))
                    .background(
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea(edges: .bottom)
                    )
                }
            }
            .navigationBarHidden(true)
    }
}

#Preview {
    let sampleBodyParts: Set<BodyPart> = [
        BodyPart(name: "Chest", iconName: "figure.strengthtraining.traditional", color: .red),
        BodyPart(name: "Arms", iconName: "figure.strengthtraining.functional", color: .green)
    ]
    
    let sampleEquipment: Set<Equipment> = [
        Equipment(name: "Dumbbells", iconName: "dumbbell", color: .blue, category: .freeWeights),
        Equipment(name: "Barbell", iconName: "figure.strengthtraining.traditional", color: .red, category: .freeWeights)
    ]
    
    WorkoutRecommendationView(
        selectedBodyParts: sampleBodyParts,
        selectedEquipment: sampleEquipment,
        onStartOver: {}
    )
}
