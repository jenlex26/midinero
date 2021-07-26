//
//  GSDigitalCardConfigTagging.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 21/07/21.
//

import Foundation
import GSSAFirebaseManager

extension GSDigitalCardConfigViewController{
    func tagDebitDigitalCardConfigViewDidAppear(){
        let tagEvent = GSSAFirebaseEvent(.custom("pageview")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta_digital").set(origin: "debito")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagDebitDigitalCardSwitchClick(isOn: Bool){
        var type = ""
        if isOn == true{
            type = "switch_on"
        }else{
            type = "switch_off"
        }
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta_digital").set(paramaters: ["type":type]).set(paramaters: ["element" : "apagar_tarjeta_digital"]).set(origin: "debito")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
}
