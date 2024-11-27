//
//  Date+.swift
//  SpotChat
//
//  Created by 최대성 on 11/27/24.
//

import Foundation

extension Date {
    
    static var isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
    static func formatDate(from isoDateString: String) -> String {
        
        if let date = isoFormatter.date(from: isoDateString) {
            return formattedString(for: date)
        }
        
        let fallbackFormatter = DateFormatter()
        fallbackFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 예: "2024-11-24 11:25:23"
        if let date = fallbackFormatter.date(from: isoDateString) {
            return formattedString(for: date)
        }
        
        return "Invalid Date"
    }

    
    private static func formattedString(for date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()

        if calendar.isDateInToday(date) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return timeFormatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            return "어제"
        } else if calendar.compare(date, to: now, toGranularity: .year) == .orderedSame {
            let monthDayFormatter = DateFormatter()
            monthDayFormatter.dateFormat = "M.d"
            return monthDayFormatter.string(from: date)
        } else {
            let fullDateFormatter = DateFormatter()
            fullDateFormatter.dateFormat = "yyyy.M.d"
            return fullDateFormatter.string(from: date)
        }
    }
}
