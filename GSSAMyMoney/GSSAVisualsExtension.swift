//
//  UIColorExtension.swift
//  GSSAFund
//
//  Created by Usuario Phinder 2020 on 04/08/21.
//

import UIKit
import GSSAVisualComponents

extension UIColor {
    class func GSVCBase300() -> UIColor{
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
}

extension UIImage{
    class func calendarIcon() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "calendar") ?? UIImage()
        }else{
            image = UIImage(named: "CalendarIcon") ?? UIImage()
        }
        return image
    }
    
    class func personIcon() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "person.crop.circle.fill")!.withRenderingMode(.alwaysTemplate).tint(with: .black)
        }else{
            image = UIImage(named: "PersonIcon") ?? UIImage()
        }
        return image
    }
    
    class func arrowLeft() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "arrow.left") ?? UIImage()
        }else{
            image = UIImage(named: "ArrowLeft") ?? UIImage()
        }
        return image
    }
    
    class func arrowRight() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "arrow.right") ?? UIImage()
        }else{
            image = UIImage(named: "ArrowRight") ?? UIImage()
        }
        return image
    }
    
    class func chevronDown() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "chevron.down") ?? UIImage()
        }else{
            image = UIImage(named: "ChevronDown") ?? UIImage()
        }
        return image
    }
    
    class func chevronRight() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "chevron.right") ?? UIImage()
        }else{
            image = UIImage(named: "ChevronRight") ?? UIImage()
        }
        return image
    }
    
    class func copyIcon() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "doc.fill") ?? UIImage()
        }else{
            image = UIImage(named: "CopyIcon") ?? UIImage()
        }
        return image
    }
    
    class func shareIcon() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "square.and.arrow.up") ?? UIImage()
        }else{
            image = UIImage(named: "ShareIcon") ?? UIImage()
        }
        return image
    }
}
