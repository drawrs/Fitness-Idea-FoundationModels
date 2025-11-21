//
//  WorkoutCompletionView.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 15/11/25.
//
import SwiftUI

// MARK: - Workout Completion View
struct WorkoutCompletionView: View {
    let onRestart: () -> Void
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
        }
    }
    
    // MARK: - Private Views
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
    
    private var actionButtons: some View {
        VStack(spacing: 16) {
            restartButton
            finishButton
        }
        .padding(.horizontal, 24)
    }
    
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
    
    private var finishButton: some View {
        Button(action: onStartOver) {
            HStack(spacing: 8) {
                Text("I'm Done")
                    .fontWeight(.semibold)
            }
            .font(.title3)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
        }
    }
}
