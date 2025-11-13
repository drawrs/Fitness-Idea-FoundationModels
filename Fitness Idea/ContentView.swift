//
//  ContentView.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 13/11/25.
//

import SwiftUI

struct BodyPart: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let iconName: String
    let color: Color
}

struct ContentView: View {
    @State private var selectedBodyParts: Set<BodyPart> = []
    
    private let bodyParts = [
        BodyPart(name: "Chest", iconName: "figure.strengthtraining.traditional", color: .red),
        BodyPart(name: "Back", iconName: "figure.mind.and.body", color: .blue),
        BodyPart(name: "Shoulders", iconName: "figure.arms.open", color: .orange),
        BodyPart(name: "Arms", iconName: "figure.strengthtraining.functional", color: .green),
        BodyPart(name: "Core", iconName: "figure.core.training", color: .purple),
        BodyPart(name: "Legs", iconName: "figure.run", color: .cyan),
        BodyPart(name: "Glutes", iconName: "figure.strengthtraining.traditional", color: .pink),
        BodyPart(name: "Cardio", iconName: "heart.fill", color: .mint)
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Text("Choose Your Workout")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Select the body parts you want to exercise today")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top)
                
                // Body parts grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(bodyParts) { bodyPart in
                        BodyPartCard(
                            bodyPart: bodyPart,
                            isSelected: selectedBodyParts.contains(bodyPart)
                        ) {
                            toggleBodyPart(bodyPart)
                        }
                        .padding(.horizontal, 5)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Action button
                if !selectedBodyParts.isEmpty {
                    VStack(spacing: 12) {
                        Text("Selected: \(selectedBodyParts.map { $0.name }.joined(separator: ", "))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: startWorkout) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("Start Workout (\(selectedBodyParts.count))")
                            }
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(.tint, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedBodyParts.isEmpty)
            .navigationBarHidden(true)
        }
    }
    
    private func toggleBodyPart(_ bodyPart: BodyPart) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedBodyParts.contains(bodyPart) {
                selectedBodyParts.remove(bodyPart)
            } else {
                selectedBodyParts.insert(bodyPart)
            }
        }
    }
    
    private func startWorkout() {
        // This is where you would navigate to the workout screen
        // or handle the workout start logic
        print("Starting workout with: \(selectedBodyParts.map { $0.name })")
    }
}

struct BodyPartCard: View {
    let bodyPart: BodyPart
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(bodyPart.color.opacity(isSelected ? 0.3 : 0.1))
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: bodyPart.iconName)
                        .font(.title2)
                        .foregroundStyle(isSelected ? bodyPart.color : .secondary)
                }
                
                Text(bodyPart.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(isSelected ? .primary : .secondary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .stroke(
                        isSelected ? bodyPart.color : Color(.systemGray4),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    ContentView()
}
