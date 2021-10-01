//
//  GSSARequestDebitCardInteractor.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 28/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAServiceCoordinator
import GSSASecurityManager
import GSSAFunctionalUtilities
import GSSASessionInfo
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

class GSSARequestDebitCardInteractor: GSSAURLSessionTaskCoordinatorBridge, GSSARequestDebitCardInteractorProtocol {
    weak var presenter: GSSARequestDebitCardPresenterProtocol?
    
    func tryGetShippingCost(body: PhysicalCardShippingAmountTransaction, Response: @escaping (PhysicalCardShippingAmountResponse?) -> ()){
        
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes/busquedas/comision"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes/busquedas/comision"
        }
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: PhysicalCardShippingAmountResponse?, error) in
            if error.code == 0 {
                Response(objRes)
            } else {
                Response(nil)
            }
        }
    }
    
    func tryRequestCard(commission: String,  Response: @escaping (RequestCardResponse?) -> ()){
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes"
        }
        
        let userName = (GSSISessionInfo.sharedInstance.gsUser.name ?? "") + " " + (GSSISessionInfo.sharedInstance.gsUser.lastName ?? "") + " " + (GSSISessionInfo.sharedInstance.gsUser.secondLastName ?? "")
        
        
        let address = Envio(idTipoTarjeta: "OK".encryptAlnova(), cliente: ConfirmCardRequestTransaccionClient.init(nombre: userName.encryptAlnova(), numeroTelefonico: GSSISessionInfo.sharedInstance.gsUser.phone?.encryptAlnova()), comision: commission.encryptAlnova(), domicilio: Domicilio.init(ciudad: requestedAddress.shared.city?.encryptAlnova(), colonia: requestedAddress.shared.suburb?.encryptAlnova(), numeroExterior: requestedAddress.shared.externalNumber?.encryptAlnova(), numeroInterior: (requestedAddress.shared.internalNumber?.encryptAlnova() ?? "".encryptAlnova()), codigoPostal: requestedAddress.shared.postalCode?.encryptAlnova(), calle: requestedAddress.shared.street?.encryptAlnova()))
        
        let body = ConfirmCardRequestBody(transaccion: ConfirmCardRequestTransaccion.init(numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.account?.number?.formatToTnuocca14Digits().encryptAlnova(), primerTokenVerificacion: customToken.shared.firstVerification, envio: address))
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: RequestCardResponse?, error) in
            if error.code == 0 {
                Response(objRes)
            } else {
                Response(nil)
            }
        }
    }
}
