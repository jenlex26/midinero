//
//  File.swift
//  BASAMyPayments
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
    
    public func showErrorViewController(message:String?,releaseLastFlow:Bool = false)->GSVTOperationStatusViewController
    {
        let subtitleErrorMessage = "Por el momento no podemos completar tu solicitud. Estamos trabajando para resolverlo."
        //let configPhone =  RemoteConfig.remoteConfig().remoteString(forKey: "iOS_SA_phone_contact") ?? ""
      //  let contactMessage:String =  "Contáctanos a través del servicio a clientes en tu Chat Linea SAPP \(configPhone)"
       // let servicemessageAlert =  getWarningBox(message: message ?? "Ocurrio algo inesperado, intentalo de nuevo mas tarde", color: .GSVCInformation200)
       // let contactAlert =  getWarningBox(message: contactMessage, color: .GSVCInformation200)
        
        return GSVTOperationStatusViewController(status: .error(title: "Algo falló", message: subtitleErrorMessage, views: []),roundButtonAction: {
            [self] in
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "RetryRequest"), object: nil, userInfo: nil))
            })
        }, plainButtonAction: {
            [self] in
            if releaseLastFlow{
                GSINAdminNavigator.shared.releaseLastFlow()
            }
            else{
                self.dismiss(animated: true, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }
        })
        
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
