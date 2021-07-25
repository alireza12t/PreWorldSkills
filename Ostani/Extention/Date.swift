//
//  Date.swift
//  Ostani
//
//  Created by ali on 7/16/21.
//

import Foundation

extension Date {
    func getString(stringDateFormat: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tehran")
        dateFormatter.locale = Locale(identifier: "fa_IR")
        dateFormatter.calendar = Calendar(identifier: .persian)
        dateFormatter.dateFormat = stringDateFormat
        let formatedDate = dateFormatter.string(from: self)
        return formatedDate.toEnglishNumber()
    }
}
