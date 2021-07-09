//
//  BASACardStatementsInteractor.swift
//  GSSAFront
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

class BASACardStatementsInteractor: GSSAURLSessionTaskCoordinatorBridge, BASACardStatementsInteractorProtocol {
    
    weak var presenter: BASACardStatementsPresenterProtocol?
    
    func getStatements(body: DebitCardStatementBody, StatementsResultData: @escaping (DebitCardStatementData?) -> ()){
        
        self.urlPath = "https://apigateway.superappbaz.com/"
        self.strPathEndpoint = "desarrollo/superapp/dinero/captacion/estados-cuenta/v1/periodos/busquedas"
        
        let bodyTest = DebitCardStatementBody(numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.mainAccount?.encryptAlnova(), fechaInicio: "10-10-2020", fechaFin: "10-10-2020")
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: bodyTest, environment: GLOBAL_ENVIROMENT) { (objRes: DebitCardStatementData?, error) in
            debugPrint(objRes as Any)
            
            if error.code == 0 {
                StatementsResultData(objRes)
            } else {
                StatementsResultData(nil)
                debugPrint(error)
            }
        }
    }
    
}
