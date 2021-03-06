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
        
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/estados-cuenta/v1/periodos/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/estados-cuenta/v1/periodos/busquedas"
        }
        
        let initalDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let initialDateString = dateFormatter.string(from: initalDate)
        
        let body = DebitCardStatementBody(numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.account?.number?.removeWhiteSpaces().encryptAlnova(), fechaInicio: initialDateString, fechaFin: "10/12/2020")
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: DebitCardStatementData?, error) in
            if error.code == 0 {
                StatementsResultData(objRes)
            } else {
                StatementsResultData(nil)
            }
        }
    }
    
    func getDocument(body: RequestDocumentBody, Document: @escaping (RequestDocumentResponse?) -> ()){
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/estados-cuenta/v1/documentos/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/estados-cuenta/v1/documentos/busquedas"
        }
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: RequestDocumentResponse?, error) in
            if error.code == 0 {
                Document(objRes)
            } else {
                Document(nil)
            }
        }
        
    }
}
