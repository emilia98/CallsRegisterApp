import Foundation

class CallDateFormat {
    private var now: Date
    private var calendar: Calendar
    private var date: Date
    
    init(_ dateAsString: String) {
        now = Date()
        calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        self.date = Date()
        self.date = extractDate(dateAsString)
    }
    
    let fullDateAndTimeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        return dateFormatter
    }()
    
    let todayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    let dayNameDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter
    }()
    
    let fullDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter
    }()
    
    private func extractDate(_ dateAsString: String) -> Date {
        let date = fullDateAndTimeFormatter.date(from: dateAsString)
        return date!
    }
    
    private func isToday() -> Bool {
        let today = calendar.startOfDay(for: now)
        return date >= today
    }
    
    private func isYesterday() -> Bool {
        let startToday = calendar.startOfDay(for: now)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: startToday)!
        return date >= yesterday && date < startToday
    }
    
    private func isInThePastWeek() -> Bool {
        let startToday = calendar.startOfDay(for: now)
        let pastWeekStart = calendar.date(byAdding: .day, value: -7, to: startToday)!
        return date >= pastWeekStart
    }
    
    func formatDate() -> String {
        if isToday() {
            return todayDateFormatter.string(from: date)
        } else if isYesterday() {
            return "Yesterday"
        } else if isInThePastWeek() {
            return dayNameDateFormatter.string(from: date)
        } else {
            return fullDateFormatter.string(from: date)
        }
    }
}
