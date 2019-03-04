//
//  ColorHelper.swift
//  TaskManager
//
//  Created by User on 04/03/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import Foundation
import UIKit.UIColor

final class ColorHelper {
    
    static let maxColorArgValue = CGFloat(1.0)
    static let minColorArgValue = CGFloat(0.0)
    
    class func toHueFloat(deg: Int) -> CGFloat{
        var value = CGFloat(Double(deg) / 359.0)
        if value < minColorArgValue {
            value = minColorArgValue
        }
        else if value > maxColorArgValue {
            value = maxColorArgValue
        }
        return value
    }
}
