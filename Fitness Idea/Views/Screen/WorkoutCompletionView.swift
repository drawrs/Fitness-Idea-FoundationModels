//
//  WorkoutCompletionView.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 15/11/25.
//
import SwiftUI

// MARK: - Workout Completion View
struct WorkoutCompletionView: View {
    /// Closure called when user wants to restart the current workout
    let onRestart: () -> Void
    
    /// Closure called when user wants to finish and return to main screen
    let onStartOver: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 32) {
                Spacer()
                
                // MARK: - Celebration Content
                celebrationContent
                
                Spacer()
                
                // MARK: - Action Buttons
                actionButtons
            }
            .navigationTitle("Complete!")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        onStartOver()
                    }
                }
            }
        }
    }
    
    // MARK: - Private Views
    
    /// The celebration content displayed when workout is completed
    private var celebrationContent: some View {
        VStack(spacing: 24) {
            Image(systemName: "trophy.fill")
                .font(.system(size: 80))
                .foregroundStyle(.yellow)
            
            VStack(spacing: 8) {
                Text("Workout Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                Text("Great job! You've finished all exercises.")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
    
    /// Action buttons for restarting workout or finishing session
    private var actionButtons: some View {
        VStack(spacing: 16) {
            restartButton
            finishButton
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }
    
    /// Button to restart the current workout
    private var restartButton: some View {
        Button(action: onRestart) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.clockwise")
                    .font(.headline)
                Text("Restart Workout")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            .foregroundStyle(.white)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(Color.accentColor, in: RoundedRectangle(cornerRadius: 16))
        }
    }
    
    /// Button to finish workout session and return to main screen
    private var finishButton: some View {
        Button(action: onStartOver) {
            HStack(spacing: 8) {
                Text("I'm Done")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            .foregroundStyle(.white)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(Color.green, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
