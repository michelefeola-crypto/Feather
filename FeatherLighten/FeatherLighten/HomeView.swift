//
//  ContentView.swift
//  FeatherLighten
//
//  Created by Foundation 35 on 25/02/26.
//

import SwiftUI

struct HomeView: View {
    
    // MARK: - Persistenza Dati (Sincronizzata con Settings)
    @AppStorage("setHour") private var setHourSelection: Double = Date().timeIntervalSince1970
    @State private var showingSettings = false // Stato per la modale
    
    // MARK: - Logica Temporale Dinamica
    private var worryTimeHour: Int {
        let date = Date(timeIntervalSince1970: setHourSelection)
        return Calendar.current.component(.hour, from: date)
    }

    private var isWorryTime: Bool {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return currentHour == worryTimeHour
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Sfondo con ultraThinMaterial come nel tuo codice originale
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    // MARK: - Header (SF Pro Standard)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Welcome")
                            .font(.system(size: 42, weight: .bold, design: .default))
                        
                        Text("Let go of your thoughts.")
                            .font(.system(size: 20, weight: .medium, design: .default))
                    }
                    .foregroundStyle(Color("Verde"))
                    .padding(.horizontal)
                    
                    Spacer()
                        .frame(height: 35)
                    
                    // MARK: - Cards
                    VStack(spacing: 28) {
                        
                        // 1. WORRY TIME CARD
                        NavigationLink(destination: Text("Schermata Worry Time")) {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(isWorryTime ? Color.white : Color(red: 187/255, green: 183/255, blue: 183/255))
                                    .frame(height: 175)
                                    .shadow(radius: isWorryTime ? 6 : 0)
                                
                                HStack {
                                    Spacer()
                                    Image("ImageWorry") // Assicurati che il nome negli Assets sia corretto
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 180)
                                        .opacity(isWorryTime ? 1.0 : 0.7)
                                }
                                
                                Text("Worry Time")
                                    .font(.system(size: 35, weight: .bold, design: .default))
                                    .foregroundStyle(isWorryTime ? Color("Verde") : .white)
                                    .padding()
                            }
                            .overlay(alignment: .bottomLeading) {
                                HStack(spacing: 8) {
                                    if !isWorryTime {
                                        Image(systemName: "lock.fill")
                                    }
                                    Text(isWorryTime ? "Available now" : "Available at \(worryTimeHour):00")
                                }
                                .font(.system(size: 17, weight: .medium, design: .default))
                                // FIX: Usiamo Color() esplicito per evitare errori di HierarchicalShapeStyle
                                .foregroundColor(isWorryTime ? Color.secondary : Color.white)
                                .padding(.leading)
                                .padding(.bottom, 24)
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(!isWorryTime)
                        
                        // 2. WRITE IT DOWN CARD
                        NavigationLink(destination: ShortNoteView()) {
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(!isWorryTime ? Color.white : Color(red: 187/255, green: 183/255, blue: 183/255))
                                    .frame(height: 175)
                                    .shadow(radius: !isWorryTime ? 6 : 0)
                                
                                HStack {
                                    Spacer()
                                    Image("ImageNote") // Assicurati che il nome negli Assets sia corretto
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 180)
                                        .opacity(!isWorryTime ? 1.0 : 0.7)
                                }
                                
                                Text("Write It Down")
                                    .font(.system(size: 35, weight: .bold, design: .default))
                                    .foregroundStyle(!isWorryTime ? Color.black : Color.white)
                                    .padding()
                            }
                            .overlay(alignment: .bottomLeading) {
                                if isWorryTime {
                                    HStack(spacing: 8) {
                                        Image(systemName: "lock.fill")
                                        Text("Now it's Worry Time")
                                    }
                                    .font(.system(size: 17, weight: .medium, design: .default))
                                    .foregroundColor(Color.white)
                                    .padding(.leading)
                                    .padding(.bottom, 24)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .disabled(isWorryTime)
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                // MARK: - Toolbar
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        Button {
                            // Azione Calendario
                        } label: {
                            Image(systemName: "calendar")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundStyle(Color("Verde"))
                        
                        // Bottone che apre la MODALE
                        Button {
                            showingSettings = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundStyle(Color("Verde"))
                    }
                }
                // MARK: - Definizione Modale Settings
                .sheet(isPresented: $showingSettings) {
                    SettingsView() // Apre il tuo file SettingsView.swift
                        .presentationDragIndicator(.visible) // Aggiunge la maniglia per chiudere
                }
            }
        }
    }
}


#Preview {
    HomeView()
}


