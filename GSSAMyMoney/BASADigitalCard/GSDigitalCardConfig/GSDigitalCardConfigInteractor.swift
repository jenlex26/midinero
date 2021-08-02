//
//  GSDigitalCardConfigInteractor.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 22/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAServiceCoordinator
import GSSASecurityManager
import GSSAFunctionalUtilities

class GSDigitalCardConfigInteractor: GSSAURLSessionTaskCoordinatorBridge, GSDigitalCardConfigInteractorProtocol {

    weak var presenter: GSDigitalCardConfigPresenterProtocol?
    
    func tryShutdownCard(body: CardStateBody,DataCard: @escaping (DigitalCardResponse?) -> ())
    {
        self.strPathEndpoint = "/superapp/dinero/captacion/gestion-tarjetas/v1/tarjetas/bloqueos"
        
//        self.urlPath = "https://apigateway.superappbaz.com/"
//        self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas/v1/tarjetas/bloqueos"
        
        sendRequest(strUrl: strPathEndpoint, method: .PUT, objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: DigitalCardResponse?, error) in
            debugPrint(objRes as Any)
            if error.code == 0 {
                DataCard(objRes)
            } else {
                DataCard(nil)
                debugPrint(error)
            }
        }
    }
    
}
