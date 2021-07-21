//
//  GSSAMyMoneyExtensions.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 29/06/21.
//

import Foundation
import UIKit
import GSSAFirebaseManager

extension UIButton {
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
              let text = self.titleLabel?.text,
              let font = self.titleLabel?.font
        else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
    
    func makeCircular(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
}

extension UIView{
    func createCurve(curvedPercent:CGFloat) ->UIBezierPath{
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.bounds.size.width, y:self.bounds.size.height - (self.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:self.bounds.size.height - (self.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        return arrowPath
    }
    
    func applyCurveToView(curvedPercent:CGFloat) {
        guard curvedPercent <= 1 && curvedPercent >= 0 else{
            return
        }
        
        let shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.path = self.createCurve(curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = self.bounds
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIViewController{
    var isOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
    }
    
    func createTag(eventName: eventNames, section: String, flow: String, screenName: String, type: String? = nil, element: String? = nil, origin: String){
        var name = ""
        switch eventName{
        case .pageView:
            name = "pageview"
        case .UIInteraction:
            name = "ui_interaction"
        }
        
        if type != nil && element != nil{
            let tagEvent = GSSAFirebaseEvent(.custom(name)).set(section: section).set(flow: flow).set(screenName: screenName).set(paramaters: ["type":type!]).set(paramaters: ["element" : element!]).set(origin: origin)
            GSSAAnalytics.firebase.tracking(event: tagEvent)
        }else{
            let tagEvent = GSSAFirebaseEvent(.custom(name)).set(section: section).set(flow: flow).set(screenName: screenName).set(origin: origin)
            GSSAAnalytics.firebase.tracking(event: tagEvent)
        }
    }
    
    enum eventNames{
        case UIInteraction
        case pageView
    }
}

extension UITableView{
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        self.layer.add(animation, forKey: "shake")
    }
    
    func renderTable() ->UIImage{
        UIGraphicsBeginImageContext(self.contentSize);
        self.scrollToRow(at: [0,0], at: UITableView.ScrollPosition.top, animated: false)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let row = self.numberOfRows(inSection: 0)
        let numberofRowthatShowinscreen = 4
        let scrollCount = row / numberofRowthatShowinscreen
        for i in 0..<scrollCount {
            self.scrollToRow(at: [0, (i+1)*numberofRowthatShowinscreen], at: UITableView.ScrollPosition.top, animated: false)
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        return image;
    }
}

extension String{
    func characterCount() -> Int{
        return self.replacingOccurrences(of: " ", with: "").count
    }
    
    func dateFormatter(format: String, outputFormat: String) -> String{
        let dateFormatterIn = DateFormatter()
        dateFormatterIn.dateFormat = format
        
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = outputFormat
        dateFormatterOut.locale = Locale(identifier: "es_MX")
        
        let dateIn = dateFormatterIn.date(from: self)
        let dateOut = dateFormatterOut.string(from: dateIn ?? Date())
        
        return dateOut.capitalized
    }
    
    func kinShipID()-> String{
        switch self.uppercased(){
        case "HERMANO/A":
            return "00"
        case "HIJO-A":
            return "01"
        case "PADRE/MADRE":
            return "02"
        case "ABUELO/A":
            return "03"
        case "CONYUGE":
            return "04"
        case "NIETO/A":
            return "05"
        case "TIO/A":
            return "06"
        case "SOBRINO/A":
            return "07"
        case "OTRO":
            return "08"
        case "PADRE":
            return "09"
        case "MADRE":
            return "10"
        case "EMPLEADO":
            return "99"
        default:
            return self
        }
    }
    
    func IDforKinship() -> String{
        switch self{
        case "00":
            return "HERMANO/A"
        case "01":
            return "HIJO-A"
        case "02":
            return "PADRE/MADRE"
        case "03":
            return "ABUELO/A"
        case "04":
            return "CONYUGE"
        case "05":
            return "NIETO/A"
        case "06":
            return "TIO/A"
        case "07":
            return "SOBRINO/A"
        case "08":
            return "OTRO"
        case "09":
            return "PADRE"
        case "10":
            return "MADRE"
        case "99":
            return "EMPLEADO"
        default:
            return self
        }
    }
    
    func removeWhiteSpaces() -> String{
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func nameFormatter() -> String{
        var formatterName = self
        let itemArray = formatterName.components(separatedBy: " ")
        if itemArray.count >= 2{
            formatterName = itemArray[0] + " " + itemArray[1]
        }
        return formatterName
    }
    
    func haveData() -> Bool{
        if self.removeWhiteSpaces().count == 0{
            return false
        }else{
            return true
        }
    }
    
    var showOnlyNumbers: String {
        let pattern = UnicodeScalar("0")..."9"
        return String(unicodeScalars
                        .compactMap { pattern ~= $0 ? Character($0) : nil })
    }
    
    func moneyToDoubleString() -> String{
        var money = self
        money = money.replacingOccurrences(of: "$", with: "")
        money = money.replacingOccurrences(of: ",", with: "")
        return money
    }
}

extension UIColor{
    class func GSVCBase300() -> UIColor{
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
}

