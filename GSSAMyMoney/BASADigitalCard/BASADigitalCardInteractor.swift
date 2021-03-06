//
//  BASADigitalCardInteractor.swift
//  BASAMyPaymentsScreens
//
//  Created Andoni Suarez on 14/05/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAServiceCoordinator
import GSSASecurityManager
import GSSAFunctionalUtilities
import GSSASessionInfo

class BASADigitalCardInteractor: GSSAURLSessionTaskCoordinatorBridge, BASADigitalCardInteractorProtocol {
    
    weak var presenter: BASADigitalCardPresenterProtocol?
    
    public func TryGetCardDigitalCardData(Body: Transaction,  DataCard: @escaping (DigitalCardResponse?) -> ())
    {
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-tarjetas-digitales/v1/tarjetas/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/gestion-tarjetas-digitales/v1/tarjetas/busquedas"
        }
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: Body, environment: GLOBAL_ENVIROMENT) { (objRes: DigitalCardResponse?, error) in
            if error.code == 0 {
                DataCard(objRes)
            } else {
                DataCard(nil)
            }
        }
    }
    
}
