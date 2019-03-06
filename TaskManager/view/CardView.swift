//
//  CardView.swift
//  TaskManager
//
//  Created by User on 27/02/2019.
//  Copyright © 2019 Saritasa inc. All rights reserved.
//

import UIKit

/// Card view style background view for the collection view cell.
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 5

    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

}
