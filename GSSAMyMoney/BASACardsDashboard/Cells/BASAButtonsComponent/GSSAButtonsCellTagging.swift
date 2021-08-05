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
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", type: "click", element: "tarjeta_digital", origin: "debito")
    }
    
    func tagSendMoneyFlow(){
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", type: "click", element: "enviar_y_pagar", origin: "debito")
    }
    
    func tagReceiveAndPayFlow(){
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", type: "click", element: "recibir_y_cobrar", origin: "debito")
    }
    
    func tagPhoneMinutesFlow(){
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", type: "click", element: "tiempo_aire", origin: "debito")
    }
    
    func tagFundAccount(){
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", type: "click", element: "fondear_cuenta", origin: "debito")
    }
}
