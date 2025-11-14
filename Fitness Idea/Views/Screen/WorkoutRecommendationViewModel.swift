import SwiftUI
import Combine
import FoundationModels

final class WorkoutRecommendationViewModel: ObservableObject {
    @Published var selectedBodyParts: Set<BodyPart>
    @Published var selectedEquipment: Set<Equipment>
    private let onStartOver: () -> Void

    private let instructions: String = ""
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
                    Generate a list of workout exercise based on user preferences.
                    
                    User Requirement:
                    - Target Muscles: \(targetMusclesList)
                    - Available Equipment: \(availableEquipmentList)
                    - For each exercise, provide: exercise_name, sets, reps, duration_seconds
                    
                    Rules:
                    1. Only include exercises relevant to the target muscles.
                    2. Only use equipment the user has.
                    3. Include a mix of equipment-based and bodyweight options.
                    4. Keep exercise naming standard and simple.
                    
                    Goal: Return 6–10 exercises that match the user’s target muscle groups and available equipment.
                    """
                }
            let response = try await languageModelSession.respond(to: prompt, generating: [ExerciseRecommendation].self)
            
            self.recommendedExercises = response.content
            
            print(response.content)
            
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}

