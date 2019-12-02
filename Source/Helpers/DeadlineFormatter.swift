//
//  DeadlineFormatter.swift
//  OverMyDeadBody
//
//  Created by Lloyd Dapaah on 12/1/19.
//  Copyright © 2019 LDLLC. All rights reserved.
//

import Foundation

public struct DeadlineFormatter {
    public static var global: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }
    
    public static var utc: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
}
