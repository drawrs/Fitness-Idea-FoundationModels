//
//  ExerciseRecommendation.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 14/11/25.
//
import Foundation

// TODO: 6. Make this model generable
struct ExerciseRecommendation: Identifiable {
    let id = UUID()
    let name: String
    let sets: Int
    let reps: Int
    let duration: String
    let googleSearchURL: String
}
