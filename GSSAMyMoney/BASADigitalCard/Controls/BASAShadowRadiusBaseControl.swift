//
//  BASAShadowRadiusBaseControl.swift
//  BASAMyPaymentsScreens
//
//  Created by BranchbitG on 12/05/21.
//

import Foundation
import UIKit

open class BASAShadowRadiusBaseControl : UIView
{
    @IBInspectable
        var buttonCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var buttonBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
         set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var buttonBorderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    @IBInspectable
    var buttonShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {

            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var buttonShadowOffset : CGSize{

        get{
            return layer.shadowOffset
        }set{

            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var buttonShadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var buttonShadowOpacity : Float {

        get{
            return layer.shadowOpacity
        }
        set {

            layer.shadowOpacity = newValue

        }
    }
}
