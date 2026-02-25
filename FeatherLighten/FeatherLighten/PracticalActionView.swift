//
//  PracticalActionView.swift
//  FeatherLighten
//
//  Created by Foundation 23 on 25/02/26.
//

import SwiftUI

struct PracticalActionView: View {
    let accent = Color(red: 38/255, green: 113/255, blue: 113/255)
    
    @State private var solution1 = ""
    @State private var solution2 = ""
    @State private var solution3 = ""
    @State private var navigateToEvaluation = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack { // Inizio Navigazione
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        // Header
                        HStack {
                            Spacer()
                            Text("Practical Worry").font(.title2.bold()).foregroundColor(accent)
                            Spacer()
                            Color.clear.frame(width: 0, height: 44)
                        }
                        .padding(.top, 10)
                        
                        Text("Think of possible solutions").font(.title3.bold())
                        
                        VStack(spacing: 20) {
                            solutionField(title: "Solution 1", text: $solution1)
                            solutionField(title: "Solution 2", text: $solution2)
                            solutionField(title: "Solution 3", text: $solution3)
                        }
                        Spacer(minLength: 120)
                    }
                    .padding(.horizontal, 30)
                }
                
                // Bottone Next
                VStack {
                    Spacer()
                    Button(action: { navigateToEvaluation = true }) {
                        Text("Next")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(solution1.isEmpty ? Color.gray.opacity(0.3) : accent)
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                    }
                    .disabled(solution1.isEmpty)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 10)
                }
            }
            // Questo collega i due file passandogli i dati
            .navigationDestination(isPresented: $navigateToEvaluation) {
                PracticalAction2View() // arguments removed to match no-argument initializer
            }
        } // Fine NavigationStack
    }
    
    func solutionField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).font(.headline)
            TextField("Start writing...", text: text, axis: .vertical)
                .lineLimit(3...10)
                .padding()
                .background(Color(UIColor.secondarySystemGroupedBackground))
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}
#Preview {
    NavigationStack {
        PracticalActionView()
    }
}

