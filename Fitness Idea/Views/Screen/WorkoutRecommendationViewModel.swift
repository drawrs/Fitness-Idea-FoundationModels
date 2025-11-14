import SwiftUI
import Combine

final class WorkoutRecommendationViewModel: ObservableObject {
    @Published var selectedBodyParts: Set<BodyPart>
    @Published var selectedEquipment: Set<Equipment>
    private let onStartOver: () -> Void
    
    init(selectedBodyParts: Set<BodyPart>, selectedEquipment: Set<Equipment>, onStartOver: @escaping () -> Void) {
        self.selectedBodyParts = selectedBodyParts
        self.selectedEquipment = selectedEquipment
        self.onStartOver = onStartOver
    }

    var recommendedExercises: [ExerciseRecommendation] {
        let parts = Array(selectedBodyParts)
        if parts.isEmpty {
            return [
                ExerciseRecommendation(name: "Full Body Circuit", sets: 3, reps: 12, duration: "8 min"),
                ExerciseRecommendation(name: "Bodyweight Squat", sets: 4, reps: 10, duration: "45 sec"),
                ExerciseRecommendation(name: "Plank Hold", sets: 3, reps: 30, duration: "60 sec")
            ]
        } else {
            let firstThree = parts.prefix(3)
            return Array(firstThree.enumerated().map { index, part in
                ExerciseRecommendation(
                    name: "\(part.name) Exercise",
                    sets: 3 + (index % 2),
                    reps: 10 + (index * 2),
                    duration: (index % 2 == 0) ? "45 sec" : "60 sec"
                )
            })
        }
    }

    func startWorkout() {
        print("Starting workout!")
    }

    func startOver() {
        onStartOver()
    }
}

