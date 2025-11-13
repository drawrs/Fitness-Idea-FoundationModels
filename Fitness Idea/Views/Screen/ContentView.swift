//
//  ContentView.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 13/11/25.
//

import SwiftUI

struct ContentView: View {
    @State private var currentStep: WorkoutStep = .bodyPartSelection
    @State private var selectedBodyParts: Set<BodyPart> = []
    @State private var selectedEquipment: Set<Equipment> = []
    
    var body: some View {
        NavigationStack {
            switch currentStep {
            case .bodyPartSelection:
                BodyPartSelectionView(
                    selectedBodyParts: $selectedBodyParts,
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = .equipmentSelection
                        }
                    }
                )
                
            case .equipmentSelection:
                EquipmentSelectionView(
                    selectedEquipment: $selectedEquipment,
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = .bodyPartSelection
                        }
                    },
                    onContinue: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = .workoutRecommendation
                        }
                    }
                )
                
            case .workoutRecommendation:
                WorkoutRecommendationView(
                    selectedBodyParts: selectedBodyParts,
                    selectedEquipment: selectedEquipment,
                    onStartOver: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedBodyParts.removeAll()
                            selectedEquipment.removeAll()
                            currentStep = .bodyPartSelection
                        }
                    }
                )
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ContentView()
}
