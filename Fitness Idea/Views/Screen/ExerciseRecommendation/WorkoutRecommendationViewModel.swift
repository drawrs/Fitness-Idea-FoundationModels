import SwiftUI
import Combine

final class WorkoutRecommendationViewModel: ObservableObject {
    @Published var selectedBodyParts: Set<BodyPart>
    @Published var selectedEquipment: Set<Equipment>
    private let onStartOver: () -> Void

    
    private var targetMusclesList: String {
        if selectedBodyParts.isEmpty { return "None" }
        return selectedBodyParts.map { "\($0)" }.sorted().joined(separator: ", ")
    }
    
    private var availableEquipmentList: String {
        // Assume Bodyweight is always available if none selected
        if selectedEquipment.isEmpty { return "Bodyweight" }
        return selectedEquipment.map { "\($0)" }.sorted().joined(separator: ", ")
    }
    
    init(selectedBodyParts: Set<BodyPart>, selectedEquipment: Set<Equipment>, onStartOver: @escaping () -> Void) {
        self.selectedBodyParts = selectedBodyParts
        self.selectedEquipment = selectedEquipment
        self.onStartOver = onStartOver
        
    }

    @Published var recommendedExercises: [ExerciseRecommendation] = []
    
    func startWorkout() {
        print("Starting workout!")
    }

    func startOver() {
        onStartOver()
    }
}

