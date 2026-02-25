//
//  ContentView.swift
//  AppFeather
//
//  Created by Foundation 23 on 24/02/26.
//

import SwiftUI

struct ShortNoteView: View {
    
    // MARK: - Properties
    let accent = Color(red: 38/255, green: 113/255, blue: 113/255)
    
    @AppStorage("setHour") private var setHourSelection: Double = Date().timeIntervalSince1970
    
    @State private var worryText = ""
    @State private var refocusText = ""
    @State private var selectedType: String? = nil
    @State private var showPopup = false
    
    @State private var MaximumLenght: Int = 100
    @State private var CurrentLenght: Int = 0
    @State private var navigateToPractical = false
    
    @Environment(\.dismiss) var dismiss
    
    private var worryTimeFormatted: String {
        let date = Date(timeIntervalSince1970: setHourSelection)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:00"
        return formatter.string(from: date)
    }
    
    var body: some View {
        // Usiamo un semplice VStack invece della ZStack esterna
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 25) {
                    
                    // SEZIONE 1: Worry
                    VStack(alignment: .leading, spacing: 12) {
                        Text("My worry right now is")
                            .font(.system(size: 20, weight: .bold))
                        
                        TextEditor(text: $worryText)
                            .frame(height: 130)
                            .padding(10)
                            .scrollContentBackground(.hidden)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator), lineWidth: 0.5))
                            .onChange(of: worryText) { oldValue, newValue in
                                CurrentLenght = newValue.count
                                if newValue.count > MaximumLenght {
                                    worryText = String(newValue.prefix(MaximumLenght))
                                }
                            }
                        
                        HStack {
                            Spacer()
                            Text("\(CurrentLenght) / \(MaximumLenght)")
                                .font(.caption)
                                .foregroundColor(CurrentLenght >= MaximumLenght ? .red : .secondary)
                        }
                    }
                    
                    // SEZIONE 2: Refocus
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Now I am going to refocus...")
                            .font(.system(size: 20, weight: .bold))
                        
                        TextEditor(text: $refocusText)
                            .frame(height: 130)
                            .padding(10)
                            .scrollContentBackground(.hidden)
                            .background(Color(UIColor.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(.separator), lineWidth: 0.5))
                    }
                    
                    // SEZIONE 3: Selection
                    VStack(alignment: .leading, spacing: 15) {
                        Text("My worry is")
                            .font(.system(size: 20, weight: .bold))
                        
                        selectionButton(title: "Practical", subtitle: "Concern that can be resolved or addressed now.")
                        selectionButton(title: "Hypothetical", subtitle: "Concerns about possible future events.")
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                Button {
                    if selectedType == "Practical" {
                        navigateToPractical = true
                    } else if selectedType == "Hypothetical" {
                        withAnimation { showPopup = true }
                    }
                } label: {
                    Text("Next")
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedType == nil ? Color.gray.opacity(0.3) : accent)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
                .disabled(selectedType == nil)
                .padding(.horizontal, 30)
                .padding(.vertical, 15)
            }
            
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea()) // Sfondo applicato qui
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Write it down")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(accent)
            }
        }
        // Gestione del Popup tramite Overlay (Più pulito)
        .overlay {
            if showPopup {
                popupView
            }
        }
        .navigationDestination(isPresented: $navigateToPractical) {
            PracticalActionView()
        }
    }
    
    // Helper Components (Buttons e Popup rimangono come funzioni o variabili)
    func selectionButton(title: String, subtitle: String) -> some View {
        let isSelected = selectedType == title
        return Button { selectedType = title } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.headline).foregroundColor(.primary)
                    Text(subtitle).font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                ZStack {
                    Circle().stroke(isSelected ? accent : Color.gray.opacity(0.5), lineWidth: 2).frame(width: 22, height: 22)
                    if isSelected { Circle().fill(accent).frame(width: 12, height: 12) }
                }
            }
            .padding().background(Color(UIColor.secondarySystemGroupedBackground)).cornerRadius(18)
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(isSelected ? accent.opacity(0.3) : Color.clear, lineWidth: 2))
        }.buttonStyle(.plain)
    }

    var popupView: some View {
        ZStack {
            Color.black.opacity(0.4).ignoresSafeArea()
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill").font(.system(size: 50)).foregroundColor(accent)
                Text("Your worry has been saved.").font(.headline)
                Text("Come back at \(worryTimeFormatted) for your worry time.").multilineTextAlignment(.center).foregroundColor(.secondary)
                Button("Done") { dismiss() }.font(.headline).frame(maxWidth: .infinity).padding().background(accent).foregroundColor(.white).clipShape(Capsule())
            }
            .padding(30).background(Color(UIColor.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 30)).padding(40)
        }
    }
}
#Preview {
    NavigationStack {
        ShortNoteView()
    }
}

