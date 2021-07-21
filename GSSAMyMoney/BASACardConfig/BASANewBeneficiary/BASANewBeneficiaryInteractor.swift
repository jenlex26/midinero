//
//  BASANewBeneficiaryInteractor.swift
//  GSSAFront
//
//  Created Desarrollo on 14/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAServiceCoordinator
import GSSASecurityManager
import GSSAFunctionalUtilities
import GSSASessionInfo

class BASANewBeneficiaryInteractor: GSSAURLSessionTaskCoordinatorBridge, BASANewBeneficiaryInteractorProtocol {
    weak var presenter: BASANewBeneficiaryPresenterProtocol?
    
    func trySetNewBeneficiary(Body: NewBeneficiaryBody, method: EKTHTTPRequestMethod, DataCard: @escaping (DigitalCardResponse?) -> ())
    {
        
        self.urlPath = "https://api.baz.app"
        self.strPathEndpoint = "/superapp/dinero/captacion/gestion-cuentas/v1/beneficiarios"
        
//        self.urlPath = "https://apigateway.superappbaz.com/"
//        self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-cuentas/v1/beneficiarios"
        
        sendRequest(strUrl: strPathEndpoint, method: method, objBody: Body, environment: GLOBAL_ENVIROMENT) { (objRes: DigitalCardResponse?, error) in
            debugPrint(objRes as Any)
            
            if error.code == 0 {
                DataCard(objRes)
            } else if error.code == 500{
                DataCard(DigitalCardResponse.init(mensaje: "", folio: "", resultado: nil))
            }else{
                DataCard(nil)
                debugPrint(error)
            }
        }
    }
    
}
