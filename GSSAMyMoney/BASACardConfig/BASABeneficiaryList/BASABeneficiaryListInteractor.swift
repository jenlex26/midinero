//
//  BASABeneficiaryListInteractor.swift
//  GSSAFront
//
//  Created Desarrollo on 14/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSASecurityManager
import GSSAServiceCoordinator

class BASABeneficiaryListInteractor: GSSAURLSessionTaskCoordinatorBridge, BASABeneficiaryListInteractorProtocol {

    weak var presenter: BASABeneficiaryListPresenterProtocol?
    
    public func tryGetBeneficiaries(account: String, beneficiaryList: @escaping (BeneficiaryListResponse?) -> ()){
        self.urlPath = "https://apigateway.superappbaz.com/"
        self.strPathEndpoint = "integracion/superapp/dinero/captacion/gestion-cuentas/v1/beneficiarios/busquedas"

        let body = BeneficiaryListBody(numeroCuenta: account)
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: body, environment: .develop) { (objRes: BeneficiaryListResponse?, error) in
            debugPrint(objRes as Any)
            if error.code == 0 {
                beneficiaryList(objRes)
            } else {
                beneficiaryList(nil)
                debugPrint(error)
            }
        }
    }
}
