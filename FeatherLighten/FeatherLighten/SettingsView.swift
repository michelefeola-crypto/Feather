//
//  SettingsView.swift
//  FeatherLighten
//
//  Created by Foundation 23 on 25/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
    }
}

  
import SwiftUI

// Helper per il colore HEX
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: 1)
    }
}

struct SettingsView: View {
    // VARIABILI SALVATE (Persistenti)
    @AppStorage("setHour") private var setHourSelection: Double = Date().timeIntervalSince1970
    @AppStorage("durationMinutes") private var durationMinutes = 15
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("leadTime") private var leadTime = 5
    
    let myAccentColor = Color(hex: "257070")
    
    // Computed property per gestire la data con AppStorage
    private var selectedDate: Binding<Date> {
        Binding(
            get: { Date(timeIntervalSince1970: setHourSelection) },
            set: { setHourSelection = $0.timeIntervalSince1970 }
        )
    }

    var body: some View {
        NavigationStack {
            List {
                // SEZIONE 1: Orario e Durata
                Section {
                    HStack {
                        Image(systemName: "clock")
                        Text("Set Hour")
                        Spacer()
                        DatePicker("", selection: selectedDate, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .tint(myAccentColor)
                    }
                    
                    HStack {
                        Image(systemName: "timer")
                        Stepper(value: $durationMinutes, in: 15...30) {
                            HStack {
                                Text("Duration time")
                                Spacer()
                                Text("\(durationMinutes) min")
                                    .fontWeight(.bold)
                                    .foregroundColor(myAccentColor)
                            }
                        }
                    }
                }
                
                // SEZIONE 2: Notifiche e Preavviso
                Section {
                    Toggle(isOn: $notificationsEnabled.animation()) {
                        HStack {
                            Image(systemName: "app.badge")
                            Text("Enable Notifications")
                        }
                    }
                    .tint(myAccentColor)
                    
                    if notificationsEnabled {
                        Picker("Remind me", selection: $leadTime) {
                            
                            Text("5 min before").tag(5)
                            Text("10 min before").tag(10)
                            Text("15 min before").tag(15)
                            Text("30 min before").tag(30)

                        }
                        .pickerStyle(.menu)
                        .tint(myAccentColor)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            // PULSANTE SALVA
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Con AppStorage i dati sono già salvati,
                        // qui puoi aggiungere un feedback o chiudere la vista
                        print("Impostazioni salvate con successo!")
                    }
                    .fontWeight(.bold)
                    .foregroundColor(myAccentColor)
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}
