//
//  GSSAMyMoneyExtensions.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 29/06/21.
//

import Foundation
import UIKit

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
}

extension UIViewController{
    var isOnScreen: Bool{
        return self.isViewLoaded && view.window != nil
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
}

extension UIColor{
   class func GSVCBase300() -> UIColor{
        return UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)
    }
}

