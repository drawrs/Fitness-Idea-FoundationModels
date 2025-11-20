//
//  ExerciseRecommendation.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 14/11/25.
//
import Foundation

struct ExerciseRecommendation: Identifiable {
    let id = UUID()
    let name: String
    let sets: Int
    let reps: Int
    let duration: String
    let googleSearchURL: String
}
