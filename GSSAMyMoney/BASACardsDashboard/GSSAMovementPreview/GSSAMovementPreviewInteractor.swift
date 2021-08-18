//
//  GSSAMovementPreviewInteractor.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 13/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAServiceCoordinator
import GSSASecurityManager
import GSSAFunctionalUtilities
import GSSASessionInfo

class GSSAMovementPreviewInteractor: GSSAURLSessionTaskCoordinatorBridge, GSSAMovementPreviewInteractorProtocol {
    weak var presenter: GSSAMovementPreviewPresenterProtocol?
    
    public func tryGetSPEIDetail(Body: SPEIDetailBody,  Response: @escaping (SPEIDetailResponse?) -> ())
    {
        self.strPathEndpoint = "/superapp/pagos/captacion/transferencias/v1/spei/busquedas"
    
        sendRequest(strUrl: strPathEndpoint, method: .POST, objBody: Body, environment: GLOBAL_ENVIROMENT) { (objRes: SPEIDetailResponse?, error) in
            debugPrint(objRes ?? "nil")
            if error.code == 0 {
                Response(objRes)
            } else {
                Response(nil)
                debugPrint(error)
            }
        }
    }

}
