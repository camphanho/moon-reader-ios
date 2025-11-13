//
//  ReadingCalendarView.swift
//  MoonReader
//
//  Reading Calendar View - lịch đọc sách
//  Tương đương BookCalendar trong Android
//

import SwiftUI

struct ReadingCalendarView: View {
    @EnvironmentObject var bookDatabase: BookDatabase
    @State private var selectedDate: Date = Date()
    @State private var readingDays: Set<Date> = []
    
    var body: some View {
        NavigationView {
            VStack {
                // Calendar
                if #available(iOS 16.0, *) {
                    CalendarView(selectedDate: $selectedDate, readingDays: readingDays)
                        .frame(height: 400)
                } else {
                    // Fallback for iOS 15
                    Text("Calendar view requires iOS 16+")
                        .foregroundColor(.secondary)
                }
                
                // Statistics for selected date
                if let dayStats = getStatsForDate(selectedDate) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Thống kê ngày \(formatDate(selectedDate))")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack(spacing: 16) {
                            StatItem(
                                icon: "clock.fill",
                                value: formatTime(dayStats.totalTime),
                                label: "Thời gian"
                            )
                            
                            StatItem(
                                icon: "text.word.spacing",
                                value: "\(dayStats.totalWords)",
                                label: "Số từ"
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
                
                Spacer()
            }
            .navigationTitle("Lịch đọc")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                loadReadingDays()
            }
        }
    }
    
    private func loadReadingDays() {
        // Extract unique dates from statistics
        readingDays = Set(bookDatabase.statistics.flatMap { $0.dates })
    }
    
    private func getStatsForDate(_ date: Date) -> DailyStats? {
        let calendar = Calendar.current
        let dayStart = calendar.startOfDay(for: date)
        let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!
        
        let dayStats = bookDatabase.statistics.filter { stat in
            stat.dates.contains { date in
                date >= dayStart && date < dayEnd
            }
        }
        
        guard !dayStats.isEmpty else { return nil }
        
        let totalTime = dayStats.reduce(0) { $0 + $1.usedTime }
        let totalWords = dayStats.reduce(0) { $0 + $1.readWords }
        
        return DailyStats(
            date: date,
            totalTime: totalTime,
            totalWords: totalWords
        )
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "vi_VN")
        return formatter.string(from: date)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
}

@available(iOS 16.0, *)
struct CalendarView: View {
    @Binding var selectedDate: Date
    let readingDays: Set<Date>
    
    var body: some View {
        CalendarViewRepresentable(selectedDate: $selectedDate, readingDays: readingDays)
    }
}

@available(iOS 16.0, *)
struct CalendarViewRepresentable: UIViewRepresentable {
    @Binding var selectedDate: Date
    let readingDays: Set<Date>
    
    func makeUIView(context: Context) -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.calendar = Calendar.current
        calendarView.locale = Locale(identifier: "vi_VN")
        calendarView.fontDesign = .rounded
        
        // Mark reading days
        let dateSelection = UICalendarSelectionSingleDate(delegate: context.coordinator)
        calendarView.selectionBehavior = dateSelection
        
        return calendarView
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        // Update calendar if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selectedDate: $selectedDate, readingDays: readingDays)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        @Binding var selectedDate: Date
        let readingDays: Set<Date>
        
        init(selectedDate: Binding<Date>, readingDays: Set<Date>) {
            self._selectedDate = selectedDate
            self.readingDays = readingDays
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            if let dateComponents = dateComponents,
               let date = Calendar.current.date(from: dateComponents) {
                selectedDate = date
            }
        }
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.headline)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

import UIKit

