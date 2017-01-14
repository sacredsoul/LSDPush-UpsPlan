//
//  Extensions.swift
//  LSDPush-upsPlan
//
//  Created by LSD on 2017/1/14.
//  Copyright © 2017年 LSD. All rights reserved.
//

import UIKit

class Extensions: NSObject {

}

extension DateFormatter {
    func dateFormatter(string format: String?) -> DateFormatter {
        let dateFormatter = DateFormatter()
        if let formatStr = format {
            dateFormatter.dateFormat = formatStr
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
        return dateFormatter
    }
    
    func date(format: String?, from dateString: String?) -> Date {
        let dateFormatter = DateFormatter().dateFormatter(string: format)
        if let dateStr = dateString {
            return dateFormatter.date(from: dateStr)!
        }
        return dateFormatter.defaultDate!
    }
    
    func string(format: String?, from originalDate: Date?) -> String {
        let dateFormatter = DateFormatter().dateFormatter(string: format)
        if let date = originalDate {
            return dateFormatter.string(from: date)
        }
        return dateFormatter.string(from: Date())
    }
}
