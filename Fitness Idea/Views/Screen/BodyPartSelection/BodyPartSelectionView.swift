//
//  ContentView.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 13/11/25.
//

import SwiftUI

struct BodyPartSelectionView: View {
    @Binding var selectedBodyParts: Set<BodyPart>
    let onContinue: () -> Void
    
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
    
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Scrollable content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header
                            VStack(spacing: 12) {
                                Text("Choose Your Workout")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.primary)
                                    .tracking(-0.5)
                                    .multilineTextAlignment(.center)
                                    .fontDesign(.rounded)
                                
                                Text("Select the body parts you want to exercise today")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                            
                            // Body parts grid
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(bodyParts) { bodyPart in
                                    BodyPartCard(
                                        bodyPart: bodyPart,
                                        isSelected: selectedBodyParts.contains(bodyPart)
                                    ) {
                                        toggleBodyPart(bodyPart)
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // Bottom padding to ensure content doesn't get cut off by the fixed button
                            Spacer(minLength: selectedBodyParts.isEmpty ? 40 : 140)
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                    // Fixed bottom action section
                    if !selectedBodyParts.isEmpty {
                        VStack(spacing: 16) {
                            Text("Selected: \(selectedBodyParts.map { $0.name }.joined(separator: ", "))")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 24)
                            
                            Button(action: startWorkout) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.headline)
                                    Text("Continue")
                                        .fontWeight(.semibold)
                                    Text("(\(selectedBodyParts.count))")
                                        .fontWeight(.medium)
                                        .opacity(0.8)
                                }
                                .font(.title3)
                                .foregroundStyle(.white)
                                .padding(.vertical, 18)
                                .frame(maxWidth: .infinity)
                                .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 16))
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.top, 16)
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea(edges: .bottom)
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedBodyParts.isEmpty)
            .navigationBarHidden(true)
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
        onContinue()
    }
}



#Preview {
    BodyPartSelectionView(
        selectedBodyParts: .constant([]),
        onContinue: {}
    )
}
