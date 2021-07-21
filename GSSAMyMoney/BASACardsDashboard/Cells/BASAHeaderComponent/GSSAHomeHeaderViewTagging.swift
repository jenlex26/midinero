//
//  GSSAHomeHeaderViewTagging.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 20/07/21.
//

import Foundation
import GSSAFirebaseManager

extension BASAHomeHeaderViewComponent{
    func tagDebitCardConfigClick(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "movimientos").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "configuracion_tarjeta"]).set(origin: "{debito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
   /* func tagCreditCardConfigClick(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "movimientos").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "configuracion_tarjeta"]).set(origin: "{credito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    } */
}
