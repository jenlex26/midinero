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
    
    func tryGetRequestedCardStatus(CardSearchResponse: @escaping () -> ()){
        self.urlPath = "https://apigateway.superappbaz.com/"
        self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/solicitudes/busquedas/estatus"
        
        let bodyProd = CardConfigCardSearchBody.init(transaccion: CardConfigCardSearchTransaccion.init(primerTokenVerificacion: GSSISessionInfo.sharedInstance.gsUserToken, sicu: GSSISessionInfo.sharedInstance.gsUser.SICU?.encryptAlnova(), numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.mainAccount?.encryptAlnova(), idTipoTarjeta: "CP".encryptAlnova()))
        
        let bodyDev = CardConfigCardSearchBody.init(transaccion: CardConfigCardSearchTransaccion.init(primerTokenVerificacion: GSSISessionInfo.sharedInstance.gsUserToken, sicu: GSSISessionInfo.sharedInstance.gsUser.SICU?.encryptAlnova(), numeroCuenta: "01271156141200001956".formatToTnuocca14Digits().encryptAlnova(), idTipoTarjeta: "CP".encryptAlnova()))
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: bodyDev, environment: GLOBAL_ENVIROMENT) { (objRes: DebitCardStatementData?, error) in
            debugPrint(objRes as Any)
            
            if error.code == 0 {
                print("correcto")
                debugPrint(objRes as Any)
            } else {
                self.customCardStatusRequest()
            }
        }
    }
    
    
    
    func customCardStatusRequest(){
        let semaphore = DispatchSemaphore (value: 0)
        let parameters = "{\r\n  \"transaccion\": {\r\n    \"primerTokenVerificacion\": \"primerTokenVerificacion\",\r\n    \"sicu\": \"20c32479be924b4f8489b80ad8fa27a7\",\r\n    \"numeroCuenta\": \"a2RcnSyhQvUc-5wdvKVu_w\"\r\n  }\r\n}"
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://apigateway.superappbaz.com/integracion/superapp/dinero/captacion/gestion-tarjetas-fisicas/v1/tarjetas/busquedas")!,timeoutInterval: Double.infinity)
        request.addValue("abc71b31f71a4303ae50c580613d814b", forHTTPHeaderField: "x-sicu")
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
        request.addValue("94a08da1fecbb6e8b46990538c7b50b2", forHTTPHeaderField: "x-token-usuario")
        request.addValue("99553877", forHTTPHeaderField: "x-id-lealtad")
        request.addValue("Bearer \(customToken.shared.bearer)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("XSRF-TOKEN=483d7698-424f-489b-ab2c-d2e96a3d55e9", forHTTPHeaderField: "Cookie")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "customCardStatusRequestResponse"), object: httpResponse.statusCode, userInfo: nil))
                print("error \(httpResponse.statusCode)")
            }
            
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    
}
