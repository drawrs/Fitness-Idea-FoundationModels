import SwiftUI
import Combine
import FoundationModels

final class WorkoutRecommendationViewModel: ObservableObject {
    @Published var selectedBodyParts: Set<BodyPart>
    @Published var selectedEquipment: Set<Equipment>
    private let onStartOver: () -> Void

    private let instructions: String = """
                You are a fitness coach AI that generates strength and conditioning exercises.

                General guidelines:
                - Focus on beginner to intermediate difficulty.
                - Use clear and conventional exercise names (e.g., “Goblet Squat”, “Plank Hold”).
                - Use realistic set and rep ranges appropriate for the exercise type.
                - Use duration only for static or isometric holds (e.g., “30s”, “45s”).
                - For dynamic exercises, set duration to “0s”.
                - Only recommend exercises that match the user’s target muscles and available equipment.
                - Keep responses concise with no explanations or extra commentary.
                """
    var languageModelSession: LanguageModelSession?
    
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
        
        setupLanguageModel()
    }

    @Published var partialRecommendedExercises: [ExerciseRecommendation.PartiallyGenerated] = []
    @Published var recommendedExercises: [ExerciseRecommendation] = []
    
    func setupLanguageModel(){
        languageModelSession = LanguageModelSession(instructions: instructions)
    }

    func startWorkout() {
        print("Starting workout!")
    }

    func startOver() {
        onStartOver()
    }
    
    func generateRecommendation() async {
        do {
            guard let languageModelSession else { return }
            
            let prompt = Prompt {
                    """
                    Generate 6–8 exercises for a single workout.

                    Target muscles: \(targetMusclesList)
                    Available equipment: \(availableEquipmentList)

                    Constraints:
                    - Every exercise must primarily work the listed target muscles.
                    - Only use the equipment listed above or pure bodyweight.
                    - Each ExerciseRecommendation represents one exercise in the workout.
                    - For static / isometric exercises (e.g., plank), set reps to 0 and use duration like "30s" or "45s".
                    - For dynamic exercises, use realistic sets and reps, and set duration to "0s".
                    """
                }
            let stream = languageModelSession.streamResponse(to: prompt, generating: [ExerciseRecommendation].self)
            
            for try await snapshot in stream {
                await MainActor.run {
                    partialRecommendedExercises = snapshot.content
                }
            }
            
            let completed = try await stream.collect()
            await MainActor.run {
                recommendedExercises = completed.content
            }

        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

