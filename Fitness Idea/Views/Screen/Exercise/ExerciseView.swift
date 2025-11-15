//
//  ExerciseView.swift
//  Fitness Idea
//
//  Created by Assistant on 11/14/25.
//

import SwiftUI

struct ExerciseView: View {
    @StateObject private var viewModel: ExerciseViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showingSafariView = false
    @State private var showingCompletionView = false
    
    init(exercises: [ExerciseRecommendation]) {
        self._viewModel = StateObject(wrappedValue: ExerciseViewModel(exercises: exercises))
    }
    
    var body: some View {
        let exercise = viewModel.safeExercise
        
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        // Exercise counter
                        HStack {
                            Text("Exercise \(viewModel.currentIndex + 1) of \(viewModel.totalExercises)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(exercise.name)
                                .font(.system(size: 42, weight: .bold, design: .rounded))
                                .frame(alignment: .leading)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Spacer()

                            Button(action: { showingSafariView = true }) {
                                Image(systemName: "info.circle")
                                    .font(.title2)
                                    .foregroundStyle(.blue)
                            }
                            .accessibilityLabel("More information about \(exercise.name)")
                        }
                        .padding(.horizontal)
                    }
                    
                    
                    Divider()
                        .overlay(Color.black.opacity(0.4))
                    
                    // Current Set section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Current Set")
                            .font(.title3.bold())
                        
                        HStack(alignment: .firstTextBaseline) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(viewModel.currentSet)/\(max(1, exercise.sets))")
                                    .font(.system(size: 44, weight: .semibold, design: .rounded))
                                Text("Sets")
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .trailing, spacing: 6) {
                                Text(viewModel.secondaryMetricDisplay)
                                    .font(.system(size: 44, weight: .semibold, design: .rounded))
                                Text(viewModel.secondaryMetricLabel)
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
                        if viewModel.isStaticHold {
                            ZStack {
                                // Background ring
                                Circle()
                                    .stroke(Color(UIColor.systemGray4).opacity(0.4), lineWidth: 22)
                                
                                // Progress ring
                                Circle()
                                    .trim(from: 0, to: viewModel.progress)
                                    .stroke(
                                        AngularGradient(
                                            gradient: Gradient(colors: [Color.cyan, Color.blue]),
                                            center: .center
                                        ),
                                        style: StrokeStyle(lineWidth: 22, lineCap: .round, lineJoin: .round)
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeInOut(duration: 0.25), value: viewModel.progress)
                                
                                // Remaining seconds large
                                Text("\(viewModel.remainingSeconds)")
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
            
            // Floating controls (cancel on left, pause/play on right)
            HStack {
                if viewModel.isStaticHold && viewModel.isRunning {
                    Button(action: viewModel.cancelCurrentSet) {
                        Image(systemName: "xmark")
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 56, height: 56)
                            .background(Circle().fill(Color.pink))
                    }
                    .accessibilityLabel("Cancel set")
                }
                
                
                Spacer()
                
                if viewModel.isWorkoutComplete {
                    // Workout complete - show completion options
                    Button(action: { showingCompletionView = true }) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3.weight(.bold))
                            Text("Workout Complete!")
                                .font(.headline)
                                .bold()
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .frame(height: 56)
                        .background(Capsule().fill(Color.green))
                    }
                    .accessibilityLabel("Workout complete")
                } else {
                    if viewModel.isStaticHold {
                        Button(action: viewModel.toggleTimer) {
                            Image(systemName: viewModel.isRunning ? "pause.fill" : "play.fill")
                                .font(.title2.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 56, height: 56)
                                .background(Circle().fill(Color(UIColor.systemGray)))
                        }
                        .accessibilityLabel(viewModel.isRunning ? "Pause" : "Start")
                    } else {
                        Button(action: viewModel.advanceAfterSetCompletion) {
                            HStack(spacing: 8) {
                                Image(systemName: viewModel.currentSet == max(1, exercise.sets) ? "forward" : "checkmark")
                                    .font(.title3.weight(.bold))
                                Text(viewModel.currentSet == max(1, exercise.sets) ? "Next exercise" : "Complete set")
                                .font(.headline)
                                .bold()
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .frame(height: 56)
                            .background(
                                Capsule().fill(
                                    viewModel.currentSet == max(1, exercise.sets) ? Color.green : Color.accentColor
                                )
                            )
                        }
                        .accessibilityLabel(
                            viewModel.isWorkoutComplete
                            ? "Finish workout"
                            : (viewModel.currentSet == max(1, exercise.sets) ? "Next exercise" : "Complete set")
                        )
                    }
                }
                
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showingSafariView) {
            SafariView(url: URL(string: exercise.googleSearchURL) ?? URL(string: "https://www.google.com")!)
        }
        .sheet(isPresented: $showingCompletionView) {
            WorkoutCompletionView(
                onRestart: {
                    showingCompletionView = false
                    viewModel.restartWorkout()
                },
                onStartOver: {
                    showingCompletionView = false
                    dismiss()
                }
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Label("Back", systemImage: "chevron.left")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                // Simple next/previous arrows to switch exercises when multiple are provided
                HStack(spacing: 16) {
                    Button(action: viewModel.prevExercise) {
                        Image(systemName: "chevron.up")
                    }
                    .disabled(!viewModel.canNavigatePrevious)
                    
                    Button(action: viewModel.nextExercise) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .navigationTitle("Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    let sample: [ExerciseRecommendation] = [
        .init(name: "Jumping Jack", sets: 1, reps: 0, duration: "30s", googleSearchURL: "https://www.google.com/search?q=jumping+jack"),
        .init(name: "Plank Hold", sets: 3, reps: 0, duration: "45s", googleSearchURL: "https://www.google.com/search?q=plank+hold")
    ]
    NavigationStack { ExerciseView(exercises: sample) }
}
