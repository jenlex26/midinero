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
    
    func tryGetShippingCost(Response: @escaping (PhysicalCardShippingAmountResponse?) -> ()){
        self.urlPath = "https://apigateway.superappbaz.com/"
        self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/busquedas/comision"
        sendRequest(strUrl: strPathEndpoint, method: .GET, arrHeaders: [], environment: .production) { (objRes: PhysicalCardShippingAmountResponse?, error) in
            if error.code == 0 {
                Response(objRes)
            } else {
                self.customRequest()
                debugPrint(error)
            }
        }
    }
    
    func tryRequestCard(commission: String,  Response: @escaping () -> ()){
        self.urlPath = "https://apigateway.superappbaz.com/"
        self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes"
        
        let address = Envio(comision: commission, idTipoTarjeta: "CP", cliente: ConfirmCardRequestTransaccionClient.init(nombre: (GSSISessionInfo.sharedInstance.gsUser.name ?? "") + " " + (GSSISessionInfo.sharedInstance.gsUser.lastName ?? ""), numeroTelefonico: GSSISessionInfo.sharedInstance.gsUser.phone), domicilio: Domicilio.init(ciudad: requestedAddress.shared.city, calle: requestedAddress.shared.street, colonia: requestedAddress.shared.suburb, codigoPostal: requestedAddress.shared.postalCode, numeroExterior: requestedAddress.shared.externalNumber, numeroInterior: requestedAddress.shared.internalNumber))
        
        let body = ConfirmCardRequestBody(transaccion: ConfirmCardRequestTransaccion.init(primerTokenVerificacion: GSSISessionInfo.sharedInstance.gsUserToken, sicu: GSSISessionInfo.sharedInstance.gsUser.SICU, numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.mainAccount, envio: address))
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: body, environment: .develop) { (objRes: PhysicalCardShippingAmountResponse?, error) in
            
            if error.code == 0 {
            } else {
                debugPrint(error)
            }
        }
    }
    
    func customRequest(){
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: URL(string: "https://apigateway.superappbaz.com/integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/busquedas/comision")!,timeoutInterval: Double.infinity)
        request.addValue("3bad1290ac4600a569162efaa09117ea", forHTTPHeaderField: "x-sicu")
        request.addValue("123e4567-e89b-12d3-a456-426655440000", forHTTPHeaderField: "x-id-interaccion")
        request.addValue("Super movil", forHTTPHeaderField: "x-nombre-dispositivo")
        request.addValue("3bad1290ac4600a569162efaa09117ea", forHTTPHeaderField: "x-id-dispositivo")
        request.addValue("Android", forHTTPHeaderField: "x-sistema-dispositivo")
        request.addValue("6.0", forHTTPHeaderField: "x-version-dispositivo")
        request.addValue("2.1.1", forHTTPHeaderField: "x-version-aplicacion")
        request.addValue("P40", forHTTPHeaderField: "x-modelo-dispositivo")
        request.addValue("Huawei", forHTTPHeaderField: "x-fabricante-dispositivo")
        request.addValue("mt6735", forHTTPHeaderField: "x-serie-procesador")
        request.addValue("Telcel", forHTTPHeaderField: "x-operador-telefonia")
        request.addValue("19.49781290", forHTTPHeaderField: "x-latitud")
        request.addValue("-99.12698712", forHTTPHeaderField: "x-longitud")
        request.addValue("SRfVZrTYvdm7mzzZmcuiDViACkAx", forHTTPHeaderField: "x-token-usuario")
        request.addValue("99553877", forHTTPHeaderField: "x-id-lealtad")
        request.addValue("Bearer \(customToken.shared.bearer)", forHTTPHeaderField: "Authorization")
        request.addValue("XSRF-TOKEN=abd6f7dc-7383-4150-aabd-544647e7d0b3", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            
            DispatchQueue.main.async {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "PhysicalCardShippingAmountResponse"), object: data, userInfo: nil))
            }
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
}
