//
//  GSSAButtonsCellTagging.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 20/07/21.
//

import Foundation
import GSSAFirebaseManager

extension BASAButtonsCell{
    func tagShowDebitDigitalCard(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "movimientos").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "tarjeta_digital"]).set(origin: "debito")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagSendMoneyFlow(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "movimientos").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "enviar_y_pagar"]).set(origin: "debito")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagReceiveAndPayFlow(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "movimientos").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "recibir_y_cobrar"]).set(origin: "debito")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagPhoneMinutesFlow(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "movimientos").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "tiempo_aire"]).set(origin: "debito")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagFundAccount(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "movimientos").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "fondear_cuenta"]).set(origin: "debito")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
}
