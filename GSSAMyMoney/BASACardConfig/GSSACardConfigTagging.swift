//
//  GSSACardConfigTagging.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 21/07/21.
//

import Foundation
import GSSAFirebaseManager

//MARK: Card Config Main Screen
extension BASACardConfigViewController{
    func tagCardConfigViewDidAppear(credit: Bool){
        var origin = ""
        if credit == true{
            origin = "{credito}"
        }else{
            origin = "{debito}"
        }
        let tagEvent = GSSAFirebaseEvent(.custom("pageview")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta").set(origin: origin)
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagCardConfigShareInfo(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "compartir_informacion_tarjeta"]).set(origin: "{debito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagCardConfigStatementClick(origin: String){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "estado_de_cuenta"]).set(origin: origin)
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagCardConfigLimitsClick(origin: String){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "limites_tarjeta"]).set(origin: origin)
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagCardConfigBeneficiaryClick(origin: String){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "beneficiarios"]).set(origin: origin)
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagCardConfigActivateCard(){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "activa_tu_tarjeta"]).set(origin: "{credito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagCardSwitchClick(isOn: Bool){
        var type = ""
        if isOn == true{
            type = "{switch_on}"
        }else{
            type = "{switch_off}"
        }
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "configuracion_tarjeta").set(paramaters: ["type":type]).set(paramaters: ["element" : "apagar_tarjeta"]).set(origin: "{credito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
}
//MARK: Card Statements Screen
extension BASACardStatementsViewController{
    func tagCardStatementsViewDidAppear(credit: Bool){
        var origin = ""
        if credit == true{
            origin = "{credito}"
        }else{
            origin = "{debito}"
        }
        let tagEvent = GSSAFirebaseEvent(.custom("pageview")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "estado_cuenta").set(origin: origin)
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagSendStatementsButtonClick(origin: String){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "estado_de_cuenta").set(paramaters: ["type":"click"]).set(paramaters: ["element" : "continuar"]).set(origin: origin)
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
}
//MARK: Card Limits Screen
extension BASACardLimitsViewController{
    func tagCardLimitsDidAppear(){
        let tagEvent = GSSAFirebaseEvent(.custom("pageview")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "limites_tarjeta").set(origin: "{debito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    func tagCardLimitButtonClick(element: String){
        let tagEvent = GSSAFirebaseEvent(.custom("ui_interaction")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "limites_tarjeta").set(paramaters: ["type":"click"]).set(paramaters: ["element" : element]).set(origin: "{debito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
}
//MARK: Card Beneficiaries Screens
extension BASABeneficiaryListViewController{
    func tagCardLimitsDidAppear(){
        let tagEvent = GSSAFirebaseEvent(.custom("pageview")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "beneficiarios").set(origin: "{debito}")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
}
