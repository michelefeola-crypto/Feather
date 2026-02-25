//
//  CalendarView.swift
//  FeatherLighten
//

import SwiftUI

struct CalendarView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            VStack {
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                Spacer()
            }
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // Action to close or clear
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.bold) // Makes it easier to see
                            .foregroundStyle(.secondary)
                    
                    }
                }
            }
        }
    }
}

#Preview {
    CalendarView()
}
