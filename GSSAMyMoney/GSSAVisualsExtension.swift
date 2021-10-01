//
//  UIColorExtension.swift
//  GSSAFund
//
//  Created by Usuario Phinder 2020 on 04/08/21.
//

import UIKit
import GSSAVisualComponents

extension UIViewController{
    func setBackButtonForOlderDevices(tint: UIColor){
        if #available(iOS 13.0, *){()}else{
            if self.view.subviews[0].subviews.count > 0{
                if self.view.subviews[0].subviews[0] is UIButton{
                    let button = (self.view.subviews[0].subviews[0] as! UIButton)
                    if button.image(for: .normal) == nil{
                        button.imageView?.contentMode = .scaleAspectFit
                        button.imageEdgeInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
                        button.setImage(UIImage.backIcon(tint: tint), for: .normal)
                    }
                }
            }
        }
    }
}

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

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneXR = "iPhone XR"
        case iPhoneX_iPhoneXS = "iPhone X,iPhoneXS"
        case iPhoneXSMax = "iPhoneXS Max"
        case unknown
    }
    
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1792:
            return .iPhoneXR
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX_iPhoneXS
        case 2688:
            return .iPhoneXSMax
        default:
            return .unknown
        }
    }
}
