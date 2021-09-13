//
//  File.swift
//  GSSAFund
//
//  Created by BranchbitG on 15/07/21.
//

import Foundation
import GSSAVisualComponents
import GSSAVisualTemplates
import UIKit
import FirebaseCore
import FirebaseRemoteConfig
import GSSAFirebaseManager
import GSSAInterceptor

extension UIViewController
{
    func getWarningMPViewController(title: String? = nil,subtitle: String? = nil, message:String?, releaseLastFlow:Bool = false) -> GSVTOperationStatusViewController {
        return prepareMPVC(title: title ?? "Advertencia", subtitle: subtitle ?? "", message: message ?? "", isWarning: true, releaseLastFlow: releaseLastFlow)
    }
    
    public func getErrorMPViewController(title: String? = nil,subtitle: String? = nil, message:String?, releaseLastFlow:Bool = false, isDouble: Bool? = false) -> GSVTOperationStatusViewController
    {//lanza este error
        return prepareMPVC(title: title ?? "Algo falló", subtitle: subtitle ?? "Por el momento no podemos completar tu solicitud. Estamos trabajando para resolverlo.", message: message ?? "Ocurrio algo inesperado, intentalo de nuevo mas tarde", isWarning: false, releaseLastFlow: releaseLastFlow, isDouble: isDouble)
    }
    
    private func prepareMPVC(title: String, subtitle: String = "", message: String = "", isWarning: Bool = false, releaseLastFlow:Bool = false, isDouble: Bool? = nil) -> GSVTOperationStatusViewController {
        let subtitleErrorMessage = subtitle
        let configPhone =  RemoteConfig.remoteConfig().remoteString(forKey: "iOS_SA_phone_contact") ?? ""
        let contactMessage:String =  "Contáctanos a través del servicio a clientes en tu Chat Linea SAPP \(configPhone)"
        let servicemessageAlert =  getWarningBox(message: message, color: .GSVCInformation200)
        let contactAlert =  getWarningBox(message: contactMessage, color: .GSVCInformation200)
        let plainButtonAction: () -> Void = {
            [self] in
            
            if releaseLastFlow
            {
                GSINAdminNavigator.shared.releaseLastFlow()
            }
            else
            {
                self.navigationController?.popToRootViewController(animated: true)

            }
        }
        var roundButtonAction: (() -> ())? = nil
        
        if let isDouble = isDouble {
            roundButtonAction = {
                [self] in
                
                if isDouble {
                    self.navigationController?.popViewController(animated: false)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            
            }
        }
        
        return isWarning
            ? GSVTOperationStatusViewController(status: .caution(title: title, message: subtitleErrorMessage, views: [servicemessageAlert,contactAlert]),plainButtonAction: plainButtonAction)
            : GSVTOperationStatusViewController(status: .error(title: title, message: subtitleErrorMessage, views: [servicemessageAlert,contactAlert]),roundButtonAction: roundButtonAction,
            plainButtonAction: plainButtonAction)
    }
    
    private func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if  let nav = self.navigationController,
            let vc = nav.viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            nav.popToViewController(vc, animated: animated)
        }
    }
    
    
    private func getWarningBox(message:String,color:UIColor)->UIView
    {
        
        let iconimage  = UIImage(named: "GSSAMPInformation",
                                 in: Bundle(for: type(of:self)),
                                 compatibleWith: nil)
        let icon = UIImageView(image: iconimage)
        
        
        
        icon.frame = CGRect(x: 15,y: 15,width: 30,height: 30)
        let label = GSVCLabel()
        label.frame = CGRect(x: 10, y: 100, width: 250, height: 300)
        label.text = message
        label.numberOfLines = 3
        label.styleType = 6
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.center = CGPoint.init(x: 180, y: 45)
        label.textAlignment = NSTextAlignment.left
        let informationview = GSVCView()
        informationview.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        informationview.backgroundColor = color
        informationview.style =  GSVCViewStyle.cardview.rawValue
        informationview.addSubview(icon)
        informationview.addSubview(label)
        return informationview
    }
    
}
