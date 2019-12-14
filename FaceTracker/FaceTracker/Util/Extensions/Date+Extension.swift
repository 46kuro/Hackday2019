//
//  Date+Extension.swift
//  Professional
//
//  Created by Shinji Kurosawa on 2018/12/29.
//  Copyright © 2018 Shinji Kurosawa. All rights reserved.
//

import Foundation

extension Date {
    
    var stringMd: String {
        return Date.dateFormatterMd().string(from: self)
    }
    
    var stringDefault: String {
        return Date.dateFormatterDefault().string(from: self)
    }
    
    static func toDate(from string: String) -> Date? {
        return dateFormatterDefault().date(from: string)
    }
    
    static func dateFormatterDefault() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .full
        dateFormatter.dateStyle = .full
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }
    
    static func dateFormatterMd() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter
    }
    
    func calclateDifference(from: Date) -> Int? {
        return Int(self.timeIntervalSince(from) / (60 * 60 * 24))
    }
    
    func isEqual(to date: Date) -> Bool {
        let cal = Calendar(identifier: .gregorian)
        if cal.component(.year, from: self) == cal.component(.year, from: date),
            cal.component(.month, from: self) == cal.component(.month, from: date),
            cal.component(.day, from: self) == cal.component(.day, from: date) {
            return true
        } else {
            return false
        }
    }
}
