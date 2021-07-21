//
//  GSSADigitalCardTagging.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 20/07/21.
//

import Foundation
import GSSAFirebaseManager

extension BASADigitalCardViewController{
    func tagDebitDigitalCardViewDidAppear(){
        let tagEvent = GSSAFirebaseEvent(.custom("pageview")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "tarjeta_digital").set(origin: "{debito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagDebitDigitalCardConfigClick(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "tarjeta_digital").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "configuracion_tarjeta_digital"]).set(origin: "{debito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagCopyDebitDigitalCardNumber(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "tarjeta_digital").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "copiar_digitos_tarjeta_digital"]).set(origin: "{debito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
}
