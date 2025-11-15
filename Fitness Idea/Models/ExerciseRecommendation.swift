//
//  ExerciseRecommendation.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 14/11/25.
//
import Foundation
import FoundationModels

@Generable
struct ExerciseRecommendation: Identifiable {
    let id = UUID()
    
    @Guide(description: "Name of the exercise")
    let name: String
    
    @Guide(description: "Number of sets the user should perform for this exercise. Use a whole number between 2 and 5.")
    let sets: Int
    
    @Guide(description: "Number of repetitions per set. Use a whole number appropriate for strength or endurance training (e.g., 8–20). For static holds, set reps to 0.")
    let reps: Int
    
    @Guide(description: "Duration of the exercise in seconds for static movements (e.g., '30s', '45s'). For non-static exercises, use '0s'.")
    let duration: String
    
    
    @Guide(description: "Google search URL for finding more information about this exercise, including proper form and technique. Example: https://www.google.com/search?q=name+of+the+exercise")
    let googleSearchURL: String
}
