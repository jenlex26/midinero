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
    class func backIcon(tint: UIColor) -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "arrow.left") ?? UIImage()
        }else{
            switch tint{
            case UIColor.white:
                image = UIImage(named: "back_white", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
            case UIColor.purple:
                image = UIImage(named: "back_purple", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
            case UIColor.systemPurple:
                image = UIImage(named: "back_purple", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
            case .GSVCPrincipal100:
                image = UIImage(named: "back_purple", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
            default:
                image = UIImage(named: "back_white", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
            }
        }
        return image
    }
    
    class func calendarIcon() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "calendar") ?? UIImage()
        }else{
            image = UIImage(named: "CalendarIcon", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
        }
        return image
    }
    
    class func personIcon() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "person.crop.circle.fill")!.withRenderingMode(.alwaysTemplate).tint(with: .black)
        }else{
            image = UIImage(named: "PersonIcon", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
        }
        return image
    }
    
    class func arrowLeft() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "arrow.left") ?? UIImage()
        }else{
            image = UIImage(named: "ArrowLeft", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
        }
        return image
    }
    
    class func arrowRight() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "arrow.right") ?? UIImage()
        }else{
            image = UIImage(named: "ArrowRight", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
        }
        return image
    }
    
    class func chevronDown() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "chevron.down") ?? UIImage()
        }else{
            image = UIImage(named: "ChevronDown", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
        }
        return image
    }
    
    class func chevronRight() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "chevron.right") ?? UIImage()
        }else{
            image = UIImage(named: "ChevronRight", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
        }
        return image
    }
    
    class func copyIcon() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "doc.fill") ?? UIImage()
        }else{
            image = UIImage(named: "CopyIcon", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
        }
        return image
    }
    
    class func shareIcon() -> UIImage{
        var image = UIImage()
        if #available(iOS 13.0, *) {
            image = UIImage(systemName: "square.and.arrow.up") ?? UIImage()
        }else{
            image = UIImage(named: "ShareIcon", in: Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney"), compatibleWith: nil) ?? UIImage()
        }
        return image
    }
}
