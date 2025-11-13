//
//  ReadingStatisticsView.swift
//  MoonReader
//
//  Reading Statistics View - hiển thị thống kê đọc
//  Tương đương PrefYearStatistics.java trong Android
//

import SwiftUI
import Charts

struct ReadingStatisticsView: View {
    @EnvironmentObject var bookDatabase: BookDatabase
    @State private var selectedPeriod: StatisticsPeriod = .week
    @State private var statistics: [ReadingStatistics] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Period selector
                    Picker("Period", selection: $selectedPeriod) {
                        Text("Tuần").tag(StatisticsPeriod.week)
                        Text("Tháng").tag(StatisticsPeriod.month)
                        Text("Năm").tag(StatisticsPeriod.year)
                        Text("Tất cả").tag(StatisticsPeriod.all)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // Summary cards
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Thời gian đọc",
                            value: formatTime(totalReadingTime),
                            icon: "clock.fill",
                            color: .blue
                        )
                        
                        StatCard(
                            title: "Số từ",
                            value: formatNumber(totalWords),
                            icon: "text.word.spacing",
                            color: .green
                        )
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Số sách",
                            value: "\(bookDatabase.books.count)",
                            icon: "books.vertical.fill",
                            color: .orange
                        )
                        
                        StatCard(
                            title: "Tốc độ đọc",
                            value: "\(averageWordsPerMinute) từ/phút",
                            icon: "speedometer",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)
                    
                    // Reading chart
                    if #available(iOS 16.0, *) {
                        ReadingChart(statistics: filteredStatistics)
                            .frame(height: 200)
                            .padding()
                    }
                    
                    // Book statistics
                    Section(header: Text("Thống kê theo sách").font(.headline).padding(.horizontal)) {
                        ForEach(bookStatistics.prefix(10)) { stat in
                            BookStatRow(stat: stat)
                        }
                    }
                }
            }
            .navigationTitle("Thống kê đọc")
            .onAppear {
                loadStatistics()
            }
        }
    }
    
    private var filteredStatistics: [ReadingStatistics] {
        let calendar = Calendar.current
        let now = Date()
        
        switch selectedPeriod {
        case .week:
            let weekAgo = calendar.date(byAdding: .day, value: -7, to: now)!
            return statistics.filter { $0.dates.contains { $0 >= weekAgo } }
        case .month:
            let monthAgo = calendar.date(byAdding: .month, value: -1, to: now)!
            return statistics.filter { $0.dates.contains { $0 >= monthAgo } }
        case .year:
            let yearAgo = calendar.date(byAdding: .year, value: -1, to: now)!
            return statistics.filter { $0.dates.contains { $0 >= yearAgo } }
        case .all:
            return statistics
        }
    }
    
    private var totalReadingTime: TimeInterval {
        filteredStatistics.reduce(0) { $0 + $1.usedTime }
    }
    
    private var totalWords: Int {
        filteredStatistics.reduce(0) { $0 + $1.readWords }
    }
    
    private var averageWordsPerMinute: Int {
        guard totalReadingTime > 0 else { return 0 }
        return Int(Double(totalWords) / (totalReadingTime / 60.0))
    }
    
    private var bookStatistics: [BookStatistic] {
        let grouped = Dictionary(grouping: filteredStatistics) { $0.bookFilename }
        return grouped.map { filename, stats in
            let totalTime = stats.reduce(0) { $0 + $1.usedTime }
            let totalWords = stats.reduce(0) { $0 + $1.readWords }
            return BookStatistic(
                bookFilename: filename,
                totalTime: totalTime,
                totalWords: totalWords
            )
        }.sorted { $0.totalTime > $1.totalTime }
    }
    
    private func loadStatistics() {
        statistics = bookDatabase.statistics
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }
    
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000000 {
            return String(format: "%.1fM", Double(number) / 1000000.0)
        } else if number >= 1000 {
            return String(format: "%.1fK", Double(number) / 1000.0)
        }
        return "\(number)"
    }
}

enum StatisticsPeriod {
    case week
    case month
    case year
    case all
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Spacer()
            }
            
            Text(value)
                .font(.title2)
                .bold()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct BookStatistic: Identifiable {
    let id = UUID()
    let bookFilename: String
    let totalTime: TimeInterval
    let totalWords: Int
}

struct BookStatRow: View {
    let stat: BookStatistic
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(stat.bookFilename)
                    .font(.headline)
                    .lineLimit(1)
                
                Text("\(formatTime(stat.totalTime)) • \(formatWords(stat.totalWords))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            ProgressView(value: Double(stat.totalTime), total: 100000)
                .frame(width: 100)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }
    
    private func formatWords(_ words: Int) -> String {
        if words >= 1000 {
            return String(format: "%.1fK từ", Double(words) / 1000.0)
        }
        return "\(words) từ"
    }
}

@available(iOS 16.0, *)
struct ReadingChart: View {
    let statistics: [ReadingStatistics]
    
    var body: some View {
        Chart {
            ForEach(groupedByDate, id: \.date) { data in
                BarMark(
                    x: .value("Ngày", data.date, unit: .day),
                    y: .value("Thời gian", data.time)
                )
                .foregroundStyle(.blue)
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { _ in
                AxisGridLine()
                AxisValueLabel(format: .dateTime.month().day())
            }
        }
    }
    
    private var groupedByDate: [(date: Date, time: TimeInterval)] {
        let grouped = Dictionary(grouping: statistics) { stat in
            Calendar.current.startOfDay(for: stat.dates.first ?? Date())
        }
        
        return grouped.map { date, stats in
            (date: date, time: stats.reduce(0) { $0 + $1.usedTime })
        }.sorted { $0.date < $1.date }
    }
}

