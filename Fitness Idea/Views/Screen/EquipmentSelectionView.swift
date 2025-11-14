//
//  EquipmentSelectionView.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 13/11/25.
//

import SwiftUI

struct EquipmentSelectionView: View {
    @Binding var selectedEquipment: Set<Equipment>
    @State private var selectedCategory: EquipmentCategory? = nil
    let onBack: () -> Void
    let onContinue: () -> Void
    
    private let equipment = [
        // Free Weights
        Equipment(name: "Dumbbells", iconName: "dumbbell", color: .blue, category: .freeWeights),
        Equipment(name: "Barbell", iconName: "figure.strengthtraining.traditional", color: .red, category: .freeWeights),
        Equipment(name: "Kettlebell", iconName: "figure.strengthtraining.functional", color: .orange, category: .freeWeights),
        Equipment(name: "Weight Plates", iconName: "circle.fill", color: .gray, category: .freeWeights),
        
        // Machines
        Equipment(name: "Cable Machine", iconName: "cable.connector", color: .purple, category: .machines),
        Equipment(name: "Leg Press", iconName: "figure.seated.side", color: .green, category: .machines),
        Equipment(name: "Lat Pulldown", iconName: "figure.strengthtraining.traditional", color: .cyan, category: .machines),
        Equipment(name: "Smith Machine", iconName: "rectangle.portrait", color: .indigo, category: .machines),
        
        // Cardio
        Equipment(name: "Treadmill", iconName: "figure.run", color: .mint, category: .cardio),
        Equipment(name: "Stationary Bike", iconName: "bicycle", color: .yellow, category: .cardio),
        Equipment(name: "Elliptical", iconName: "figure.elliptical", color: .pink, category: .cardio),
        Equipment(name: "Rowing Machine", iconName: "figure.rower", color: .teal, category: .cardio),
        
        // Bodyweight
        Equipment(name: "Pull-up Bar", iconName: "minus", color: .brown, category: .bodyweight),
        Equipment(name: "Parallel Bars", iconName: "equal", color: .orange, category: .bodyweight),
        Equipment(name: "Mat", iconName: "rectangle", color: .purple, category: .bodyweight),
        Equipment(name: "None (Bodyweight)", iconName: "figure.strengthtraining.functional", color: .green, category: .bodyweight),
        
        // Accessories
        Equipment(name: "Resistance Bands", iconName: "wave.3.right", color: .red, category: .accessories),
        Equipment(name: "Medicine Ball", iconName: "circle.fill", color: .blue, category: .accessories),
        Equipment(name: "Foam Roller", iconName: "cylinder", color: .gray, category: .accessories),
        Equipment(name: "TRX Straps", iconName: "triangle", color: .yellow, category: .accessories)
    ]
    
    var filteredEquipment: [Equipment] {
        if let category = selectedCategory {
            return equipment.filter { $0.category == category }
        }
        return equipment
    }
    
    var body: some View {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Scrollable content
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header with back button
                            VStack(spacing: 12) {
                                
                                Text("Select Equipment")
                                    .font(.largeTitle)
                                    .fontWeight(.heavy)
                                    .foregroundStyle(.primary)
                                    .tracking(-0.5)
                                    .multilineTextAlignment(.center)
                                
                                Text("Choose the equipment you have available for your workout")
                                    .font(.title3)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding(.top, 20)
                            .padding(.horizontal, 20)
                            
                            // Category filter
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    CategoryFilterButton(
                                        title: "All",
                                        isSelected: selectedCategory == nil
                                    ) {
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedCategory = nil
                                        }
                                    }
                                    
                                    ForEach(EquipmentCategory.allCases, id: \.self) { category in
                                        CategoryFilterButton(
                                            title: category.rawValue,
                                            isSelected: selectedCategory == category
                                        ) {
                                            withAnimation(.easeInOut(duration: 0.2)) {
                                                selectedCategory = selectedCategory == category ? nil : category
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 20)
                            }
                            
                            // Equipment grid
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 20) {
                                ForEach(filteredEquipment) { equipment in
                                    EquipmentCard(
                                        equipment: equipment,
                                        isSelected: selectedEquipment.contains(equipment)
                                    ) {
                                        toggleEquipment(equipment)
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                            .padding(.horizontal, 20)
                            .animation(.easeInOut(duration: 0.3), value: selectedCategory)
                            
                            // Bottom padding to ensure content doesn't get cut off by the fixed button
                            Spacer(minLength: selectedEquipment.isEmpty ? 40 : 140)
                        }
                    }
                    .scrollIndicators(.hidden)
                    
                    // Fixed bottom action section
                    if !selectedEquipment.isEmpty {
                        VStack(spacing: 16) {
                            Text("Selected: \(selectedEquipment.map { $0.name }.joined(separator: ", "))")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.horizontal, 24)
                            
                            Button(action: continueToWorkout) {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.headline)
                                    Text("Continue")
                                        .fontWeight(.semibold)
                                    Text("(\(selectedEquipment.count))")
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
//                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 20))
                        .background(
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea(edges: .bottom)
                        )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: selectedEquipment.isEmpty)
            .navigationBarHidden(true)
    }
    
    private func toggleEquipment(_ equipment: Equipment) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedEquipment.contains(equipment) {
                selectedEquipment.remove(equipment)
            } else {
                selectedEquipment.insert(equipment)
            }
        }
    }
    
    private func continueToWorkout() {
        onContinue()
    }
}


#Preview {
    EquipmentSelectionView(
        selectedEquipment: .constant([]),
        onBack: {},
        onContinue: {}
    )
}
