//
//  ExerciseView.swift
//  Fitness Idea
//
//  Created by Assistant on 11/14/25.
//

import SwiftUI
import Combine

struct ExerciseView: View {
    let exercises: [ExerciseRecommendation]

    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex: Int = 0

    // Timer state
    @State private var isRunning: Bool = false
    @State private var remainingSeconds: Int = 0
    @State private var totalSeconds: Int = 0
    @State private var currentSet: Int = 1

    // A 1-second ticking timer
    private let tick = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var isStaticHold: Bool {
        safeExercise.reps == 0
    }

    var body: some View {
        let exercise = safeExercise

        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 24) {
                    // Exercise name
                    Text(exercise.name)
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)

                    Divider()
                        .overlay(Color.black.opacity(0.4))

                    // Current Set section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Set")
                            .font(.title3.bold())

                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(currentSet)/\(max(1, exercise.sets))")
                                    .font(.system(size: 44, weight: .semibold, design: .rounded))
                                Text("Sets")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)

                            VStack(alignment: .trailing, spacing: 6) {
                                Text(secondaryMetricDisplay)
                                    .font(.system(size: 44, weight: .semibold, design: .rounded))
                                Text(secondaryMetricLabel)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                    .padding(.horizontal)

                    Divider()
                        .overlay(Color.black.opacity(0.4))

                    // Metric display
                    Group {
                        if isStaticHold {
                            ZStack {
                                // Background ring
                                Circle()
                                    .stroke(Color(UIColor.systemGray4).opacity(0.4), lineWidth: 22)

                                // Progress ring
                                Circle()
                                    .trim(from: 0, to: progress)
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                            center: .center
                                        ),
                                        style: StrokeStyle(lineWidth: 22, lineCap: .round, lineJoin: .round)
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeInOut(duration: 0.25), value: progress)


                                // Remaining seconds large
                                Text("\(remainingSeconds)")
                                    .font(.system(size: 96, weight: .bold, design: .rounded))
                                    .monospacedDigit()
                            }
                            .frame(minHeight: 220)

                        }
                    }
                    .padding(.bottom, 80)
                    .padding(50)
                    
                }
            }
            .background(Color(UIColor.systemGray6).opacity(0.25))
            .onAppear { configureTimer(for: safeExercise) }
            .onChange(of: currentIndex) { _ in configureTimer(for: safeExercise) }
            .onReceive(tick) { _ in tickDownIfNeeded() }

            // Floating controls (cancel on left, pause/play on right)
            HStack {
                Button(action: cancelCurrentSet) {
                    Image(systemName: "xmark")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 56, height: 56)
                        .background(Circle().fill(Color.pink))
                }
                .accessibilityLabel("Cancel set")

                Spacer()

                if isStaticHold {
                    Button(action: { isRunning.toggle() }) {
                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(Color(UIColor.systemGray)))
                    }
                    .accessibilityLabel(isRunning ? "Pause" : "Start")
                } else {
                    Button(action: { advanceAfterSetCompletion() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark")
                                .font(.title3.weight(.bold))
                            Text("Complete Set")
                                .font(.headline)
                                .bold()
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(Capsule().fill(Color.green))
                    }
                    .accessibilityLabel("Complete set")
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                // Simple next/previous arrows to switch exercises when multiple are provided
                HStack(spacing: 16) {
                    Button(action: prevExercise) {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(exercises.count <= 1)

                    Button(action: nextExercise) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .navigationTitle("Workout")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Derived

    private var secondaryMetricLabel: String {
        isStaticHold ? "Duration (Sec)" : "Reps"
    }

    private var secondaryMetricDisplay: String {
        isStaticHold ? String(totalSeconds) : String(max(0, safeExercise.reps))
    }

    private var safeExercise: ExerciseRecommendation {
        exercises.indices.contains(currentIndex) ? exercises[currentIndex] : .init(name: "Exercise", sets: 1, reps: 0, duration: "30s")
    }

    private var progress: CGFloat {
        guard totalSeconds > 0 else { return 0 }
        return 1 - CGFloat(remainingSeconds) / CGFloat(totalSeconds)
    }

    // MARK: - Actions

    private func configureTimer(for exercise: ExerciseRecommendation) {
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

    private func cancelCurrentSet() {
        isRunning = false
        remainingSeconds = totalSeconds
    }

    private func advanceAfterSetCompletion() {
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

    private func nextExercise() {
        guard !exercises.isEmpty else { return }
        currentIndex = (currentIndex + 1) % exercises.count
        configureTimer(for: safeExercise)
    }

    private func prevExercise() {
        guard !exercises.isEmpty else { return }
        currentIndex = (currentIndex - 1 + exercises.count) % exercises.count
        configureTimer(for: safeExercise)
    }

    // MARK: - Utilities

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
}

#Preview {
    let sample: [ExerciseRecommendation] = [
        .init(name: "Jumping Jack", sets: 1, reps: 0, duration: "30s"),
        .init(name: "Plank Hold", sets: 3, reps: 0, duration: "45s")
    ]
    NavigationStack { ExerciseView(exercises: sample) }
}
