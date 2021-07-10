//
//  GSSANewBeneficiaryAddressInteractor.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 30/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAServiceCoordinator
import GSSASecurityManager
import GSSAFunctionalUtilities
import GSSASessionInfo

class GSSANewBeneficiaryAddressInteractor: GSSAURLSessionTaskCoordinatorBridge, GSSANewBeneficiaryAddressInteractorProtocol {
    
    weak var presenter: GSSANewBeneficiaryAddressPresenterProtocol?
    
    func trySetNewBeneficiary(CP: String, LocationInfo: @escaping (zipResponse?) -> ()){
        self.urlPath = "https://apigateway.superappbaz.com/integracion/superapp/enrolamiento/cartografia/catalogos/v1"
        self.sendRequest(strUrl: "/colonias/detalles?codigoPostal=\(CP)", method: .GET){ (objRes : zipResponse?, error) in
            if error.code == 0{
                print("Ok")
            }else{
                print("Not Ok")
            }

        }
    }
    
}
