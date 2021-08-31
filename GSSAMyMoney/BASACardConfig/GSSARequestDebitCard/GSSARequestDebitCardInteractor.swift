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
    
    func tryGetShippingCost(body: PhysicalCardShippingAmountBody, Response: @escaping (PhysicalCardShippingAmountResponse?) -> ()){
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/busquedas/comision"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/busquedas/comision"
        }
        sendRequest(strUrl: strPathEndpoint, method: .GET, environment: GLOBAL_ENVIROMENT) { (objRes: PhysicalCardShippingAmountResponse?, error) in
            if error.code == 0 {
                Response(objRes)
            } else {
                debugPrint(error)
            }
        }
    }
    
    func tryRequestCard(commission: String,  Response: @escaping () -> ()){
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/busquedas/comision"
        }
        
        
        let address = Envio(comision: commission, idTipoTarjeta: "CP", cliente: ConfirmCardRequestTransaccionClient.init(nombre: (GSSISessionInfo.sharedInstance.gsUser.name ?? "") + " " + (GSSISessionInfo.sharedInstance.gsUser.lastName ?? ""), numeroTelefonico: GSSISessionInfo.sharedInstance.gsUser.phone), domicilio: Domicilio.init(ciudad: requestedAddress.shared.city, calle: requestedAddress.shared.street, colonia: requestedAddress.shared.suburb, codigoPostal: requestedAddress.shared.postalCode, numeroExterior: requestedAddress.shared.externalNumber, numeroInterior: requestedAddress.shared.internalNumber))
        
        let body = ConfirmCardRequestBody(transaccion: ConfirmCardRequestTransaccion.init(primerTokenVerificacion: GSSISessionInfo.sharedInstance.gsUserToken, sicu: GSSISessionInfo.sharedInstance.gsUser.SICU, numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.mainAccount, envio: address))
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: body, environment: .develop) { (objRes: PhysicalCardShippingAmountResponse?, error) in
            
            if error.code == 0 {
            } else {
                debugPrint(error)
            }
        }
    }
}
