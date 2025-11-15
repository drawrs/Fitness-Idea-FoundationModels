//
//  ExerciseViewModel.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 15/11/25.
//

import SwiftUI
import Combine

@MainActor
final class ExerciseViewModel: ObservableObject {
    
    @Published var currentIndex: Int = 0
    @Published var isRunning: Bool = false
    @Published var remainingSeconds: Int = 0
    @Published var totalSeconds: Int = 0
    @Published var currentSet: Int = 1
    
    private let exercises: [ExerciseRecommendation]
    private var tickerCancellable: AnyCancellable?
    
    init(exercises: [ExerciseRecommendation]) {
        self.exercises = exercises
        setupTimer()
        configureTimer(for: safeExercise)
    }
    
    var safeExercise: ExerciseRecommendation {
        exercises.indices.contains(currentIndex) 
            ? exercises[currentIndex] 
        : .init(name: "Exercise", sets: 1, reps: 0, duration: "30s", googleSearchURL: "https://www.google.com/search?q=jumping+jack")
    }
    
    var isStaticHold: Bool {
        safeExercise.reps == 0
    }
    
    var progress: CGFloat {
        guard totalSeconds > 0 else { return 0 }
        return 1 - CGFloat(remainingSeconds) / CGFloat(totalSeconds)
    }
    
    var secondaryMetricLabel: String {
        isStaticHold ? "Duration (Sec)" : "Reps"
    }
    
    var secondaryMetricDisplay: String {
        isStaticHold ? String(totalSeconds) : String(max(0, safeExercise.reps))
    }
    
    var canNavigatePrevious: Bool {
        exercises.count > 1
    }
    
    private func setupTimer() {
        tickerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tickDownIfNeeded()
            }
    }
    
    func configureTimer(for exercise: ExerciseRecommendation) {
        // For static holds (reps == 0), use duration (e.g., "45s").
        // For rep-based movements (reps > 0), no countdown timer is used.
        if exercise.reps == 0 {
            let seconds = parseSeconds(exercise.duration) ?? 30
            totalSeconds = max(1, seconds)
            remainingSeconds = totalSeconds
            isRunning = false
            currentSet = 1
        } else {
            totalSeconds = 0
            remainingSeconds = 0
            isRunning = false
            currentSet = 1
        }
    }
    
    private func tickDownIfNeeded() {
        guard isStaticHold, isRunning, remainingSeconds > 0 else { return }
        remainingSeconds -= 1
        if remainingSeconds == 0 {
            // Auto-advance set or next exercise
            advanceAfterSetCompletion()
        }
    }
    
    func toggleTimer() {
        isRunning.toggle()
    }
    
    func cancelCurrentSet() {
        isRunning = false
        remainingSeconds = totalSeconds
    }
    
    func advanceAfterSetCompletion() {
        if currentSet < max(1, safeExercise.sets) {
            currentSet += 1
            remainingSeconds = totalSeconds
            // Keep running into next set
            isRunning = true
        } else {
            // Completed exercise; move to next if available
            nextExercise()
        }
    }
    
    // MARK: - Navigation
    func nextExercise() {
        guard !exercises.isEmpty else { return }
        currentIndex = (currentIndex + 1) % exercises.count
        configureTimer(for: safeExercise)
    }
    
    func prevExercise() {
        guard !exercises.isEmpty else { return }
        currentIndex = (currentIndex - 1 + exercises.count) % exercises.count
        configureTimer(for: safeExercise)
    }
    
    private func parseSeconds(_ text: String) -> Int? {
        // Accept formats like "45s", "45", "00:45"
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.contains(":") {
            // mm:ss
            let parts = trimmed.split(separator: ":").compactMap { Int($0) }
            if parts.count == 2 { return parts[0] * 60 + parts[1] }
        }
        let digits = trimmed.filter { $0.isNumber }
        if let n = Int(digits) { return n }
        return nil
    }
    
    deinit {
        tickerCancellable?.cancel()
    }
}
