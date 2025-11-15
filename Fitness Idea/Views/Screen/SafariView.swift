//
//  SafariView.swift
//  Fitness Idea
//
//  Created by Rizal Hilman on 15/11/25.
//

import SwiftUI
import SafariServices

// MARK: - Safari View
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed
    }
}
