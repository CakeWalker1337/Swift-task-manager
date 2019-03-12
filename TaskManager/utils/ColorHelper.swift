//
//  ColorHelper.swift
//  TaskManager
//
//  Created by User on 04/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import UIKit.UIColor

/// Util class contains some constants of the color args and helpful methods for converting colors.
final class ColorHelper {

    static let maxColorArgValue = CGFloat(1.0)
    static let minColorArgValue = CGFloat(0.0)
    static private let maxCustomHueValue = 130
    static private let maxCustomSaturationValue = CGFloat(0.4)
    static private let maxDegreeValue = 360.0

    /// Converts int value of hue (degrees by default) to CGFloat value.
    ///
    /// - Parameter deg: the degree value for converting.
    /// - Returns: Corresponding float value
    class func toHueFloat(deg: Int) -> CGFloat {
        var value = CGFloat(Double(deg) / maxDegreeValue)
        if value < minColorArgValue {
            value = minColorArgValue
        } else if value > maxColorArgValue {
            value = maxColorArgValue
        }
        return value
    }

    /// Calculates the color by due date.
    ///
    /// - Parameter dueDate: date to calculate the color
    /// - Returns: color object
    class func calculateCellColorByDueDate(dueDate: Date) -> UIColor {
        var backgroundCellColor: UIColor
        let seconds = Int(dueDate.timeIntervalSince(Date()))

        if abs(seconds) / DateHelper.SecondsInMinute > 0 {

            if seconds > DateHelper.SecondsInWeek {
                backgroundCellColor = UIColor(hue: ColorHelper.toHueFloat(deg: maxCustomHueValue),
                                              saturation: maxCustomSaturationValue,
                                              brightness: ColorHelper.maxColorArgValue,
                                              alpha: ColorHelper.maxColorArgValue)
            } else if seconds < 0 {
                backgroundCellColor = UIColor.gray
            } else {
                backgroundCellColor = UIColor(hue: (CGFloat(seconds) /
                    CGFloat(DateHelper.SecondsInWeek)) * ColorHelper.toHueFloat(deg: maxCustomHueValue),
                                              saturation: maxCustomSaturationValue,
                                              brightness: ColorHelper.maxColorArgValue,
                                              alpha: ColorHelper.maxColorArgValue)
            }
        } else {
            backgroundCellColor = UIColor(hue: ColorHelper.minColorArgValue,
                                          saturation: maxCustomSaturationValue,
                                          brightness: ColorHelper.maxColorArgValue,
                                          alpha: ColorHelper.maxColorArgValue)
        }
        return backgroundCellColor
    }
}
