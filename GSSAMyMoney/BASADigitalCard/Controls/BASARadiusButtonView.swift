//
//  BASAShadowButtonView.swift
//  BASAMyPaymentsScreens
//
//  Created by BranchbitG on 12/05/21.
//

import Foundation
import UIKit

 open class BASARadiusButtonView : UIButton{
    @IBInspectable public var buttonCornerRadius: CGFloat {
        get{
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    
}

