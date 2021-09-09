//
//  BASACardConfigInteractor.swift
//  TEST3
//
//  Created Desarrollo on 13/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAServiceCoordinator
import GSSASecurityManager
import GSSASessionInfo
import GSSAFunctionalUtilities

class BASACardConfigInteractor:  GSSAURLSessionTaskCoordinatorBridge,  BASACardConfigInteractorProtocol {
    weak var presenter: BASACardConfigPresenterProtocol?
    
    func tryGetRequestedCardStatus(CardSearchResponse: @escaping (CardStatusResponse?) -> ()){
        var body = CardConfigCardSearchBody.init()
        
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes/busquedas/estatus"
            
            body = CardConfigCardSearchBody.init(transaccion: CardConfigCardSearchTransaccion.init(idTipoTarjeta: "OK".encryptAlnova(), numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.mainAccount?.formatToTnuocca14Digits().encryptAlnova(), primerTokenVerificacion: GSSISessionInfo.sharedInstance.gsUserToken))
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes/busquedas/estatus"
            
            body = CardConfigCardSearchBody.init(transaccion: CardConfigCardSearchTransaccion.init(idTipoTarjeta: "OK".encryptAlnova(), numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.mainAccount?.formatToTnuocca14Digits().encryptAlnova(), primerTokenVerificacion: customToken.shared.firstVerification))
        }
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: CardStatusResponse?, error) in
            debugPrint(objRes as Any)
            //NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "customCardStatusRequestResponse"), object: error.code, userInfo: nil))
            if error.code == 0{
                CardSearchResponse(objRes)
            }else{
                CardSearchResponse(nil)
            }
        }
    }
    
    func tryGetRequestCardInfo(){
        var body = CardConfigCardInfoBody.init()
        
        body = CardConfigCardInfoBody.init(transaccion: CardConfigCardInfoTransaccion.init(numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.mainAccount?.formatToTnuocca14Digits().encryptAlnova(), primerTokenVerificacion: customToken.shared.firstVerification))
        
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/busquedas"
        }
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: DebitCardStatementData?, error) in
            
            debugPrint(objRes as Any)
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "customCardStatusRequestResponse"), object: error.code, userInfo: nil))
        }
    }
}
