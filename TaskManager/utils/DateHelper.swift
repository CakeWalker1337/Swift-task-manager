//
//  DateHelper.swift
//  TaskManager
//
//  Created by User on 22/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation

class DateHelper {
    
    static let SecondsInYear = 31536000
    static let SecondsInMonth = 2592000
    static let SecondsInWeek = 604800
    static let SecondsInDay = 86400
    static let SecondsInHour = 3600
    static let SecondsInMinute = 60
    
    class func formatDateToRemainingTimeStringFormat(date: Date) -> String {
        var seconds = Int(date.timeIntervalSince(Date()))
        if abs(seconds) / DateHelper.SecondsInMinute > 0 {
            var resultDateString: String = ""
            var postScript: String = ""
            
            if seconds > 0 {
                postScript.append("left")
            } else {
                postScript.append("ago")
            }
            
            seconds = abs(seconds)
            
            if seconds / DateHelper.SecondsInYear > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInYear)Y ")
                seconds %= DateHelper.SecondsInYear
            }
            if seconds / DateHelper.SecondsInMonth > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInMonth)M ")
                seconds %= DateHelper.SecondsInMonth
            }
            if seconds / DateHelper.SecondsInDay > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInDay)d ")
                seconds %= DateHelper.SecondsInDay
            }
            if seconds / DateHelper.SecondsInHour > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInHour)h ")
                seconds %= DateHelper.SecondsInHour
            }
            if seconds / DateHelper.SecondsInMinute > 0 {
                resultDateString.append("\(seconds / DateHelper.SecondsInMinute)m ")
                seconds %= DateHelper.SecondsInMinute
            }
            return resultDateString + postScript
        } else {
            return "now"
        }
    }
}
