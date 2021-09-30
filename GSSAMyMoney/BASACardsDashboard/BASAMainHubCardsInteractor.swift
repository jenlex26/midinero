//
//  BASAMainHubCardsInteractor.swift
//  GSSAFront
//
//  Created Desarrollo on 17/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAServiceCoordinator
import GSSASecurityManager
import GSSASessionInfo
import GSSAFunctionalUtilities

open class BASAMainHubCardsInteractor: GSSAURLSessionTaskCoordinatorBridge, BASAMainHubCardsInteractorProtocol{
    weak var presenter: BASAMainHubCardsPresenterProtocol?
    
    func tryGetUserActivations(UserActivationsResponse: @escaping () -> ()){
        self.urlPath = "https://apigateway.superappbaz.com/"
        self.strPathEndpoint = "integracion/superapp/prestamos/tarjeta-credito/v1/tarjetas/busquedas/cu"
        
        struct userLendsBody: Codable {}
        let body = userLendsBody.init()
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], environment: GLOBAL_ENVIROMENT) { (objRes: BalanceResponse?, error) in
            print(body)
            print(objRes ?? "null")
            
            if error.code == 0 {
                
                //   UserActivationsResponse(objRes)
            } else {
                //UserActivationsResponse(nil)
                debugPrint(error)
            }
        }
        
    }
    
    //MARK: - DEBIT
    func TryGetDebitCardBalance(Account:[String:String], Balance: @escaping (BalanceResponse?) -> ()){
        let requestBody = TransationBalanceRequest(transaccion: TransationItem(folio: (GSSISessionInfo.sharedInstance.gsUser.SICU?.encryptAlnova() ?? "")))
        
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/cuentas/v1/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/cuentas/v1/busquedas"
        }
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: requestBody, environment: GLOBAL_ENVIROMENT) { (objRes: BalanceResponse?, error) in
            
            if error.code == 0 {
                if (objRes?.resultado.cliente?.cuentas?.first?.saldoDisponible) != nil{
                    Balance(objRes)
                }else{
                    Balance(objRes)
                }
            } else {
                Balance(nil)
                debugPrint(error)
            }
        }
    }
    
    func TryGetDebitCardMovementsV2(Body: MovimientosBodyv2, Movements: @escaping (DebitCardTransactionV2?) -> ()) {
        
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/dinero/captacion/cuentas/v2/movimientos/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/dinero/captacion/cuentas/v2/movimientos/busquedas"
        }
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: Body, environment: GLOBAL_ENVIROMENT) { (objRes: DebitCardTransactionV2?, error) in
            
            if error.code == 0{
                Movements(objRes)
            } else if error.code == 400{
                Movements(DebitCardTransactionV2.init(mensaje: "", folio: "", resultado: DebitCardTransactionResultV2.init(movimientos:[])))
            }else{
                Movements(nil)
                debugPrint(error)
            }
        }
    }
    
    //MARK: - LENDS
    func tryGetUserLends(Lends: @escaping (LendsResponse?) -> ()){
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/pagos/creditos/agenda-pagos/v1/credimax/pagos-pendientes"
        }else{
            self.strPathEndpoint = "/superapp/pagos/creditos/agenda-pagos/v1/credimax/pagos-pendientes"
        }
        
        struct userLendsBody: Codable { }
        let body = userLendsBody.init()
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: LendsResponse?, error) in
            print(body)
            debugPrint(objRes as Any)
            
            let response = objRes
            
            if error.code == 0 {
                Lends(response)
            } else {
                Lends(nil)
                debugPrint(error)
            }
        }
    }
    
    //MARK: - CREDIT
    func tryGetCreditCardNumber(CardInfoResponse: @escaping (CreditCardInfoResponse?) -> ()){
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/prestamos/tarjeta-credito/v1/tarjetas/busquedas/cu"
        }else{
            self.strPathEndpoint = "/superapp/prestamos/tarjeta-credito/v1/tarjetas/busquedas/cu"
        }
        
        struct userLendsBody: Codable {  }
        let body = userLendsBody.init()
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: body, environment: GLOBAL_ENVIROMENT) { (objRes: CreditCardInfoResponse?, error) in
            if error.code == 0 {
                CardInfoResponse(objRes)
            } else {
                CardInfoResponse(nil)
                debugPrint(error)
            }
        }
    }
    
    func tryGetCreditCardData(Body: CreditCardBody, CreditCardData: @escaping (CreditCardResponse?) -> ()){
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/prestamos/tarjeta-credito/v1/tarjetas/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/prestamos/tarjeta-credito/v1/tarjetas/busquedas"
        }

        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: Body, environment: GLOBAL_ENVIROMENT) { (objRes: GenericRawCreditCardResponse?, error) in
            print(Body)
            debugPrint(objRes as Any)
            let response = objRes?.body
            if error.code == 0 {
                CreditCardData(response)
            } else {
                CreditCardData(nil)
                debugPrint(error)
            }
        }
    }
    
    func tryGetCreditCardBalance(Body: CreditCardBalanceBody, CreditCardBalance: @escaping (CreditCardBalanceResponse?) -> ()){
        
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/prestamos/tarjeta-credito/v1/tarjetas/saldos/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/prestamos/tarjeta-credito/v1/tarjetas/saldos/busquedas"
        }
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: Body, environment: GLOBAL_ENVIROMENT) { (objRes: GenericRawCreditCardBalanceResponse?, error) in
            debugPrint(objRes as Any)
            let response = objRes?.body
            
            if error.code == 0 {
                CreditCardBalance(response)
            } else {
                CreditCardBalance(nil)
                debugPrint(error)
            }
        }
    }
    
    func tryGetCreditCardMovements(Body: CreditCardMovementsBody, CreditCardMovements: @escaping (CreditCardMovementsResponse?) -> ()){
        
        if GLOBAL_ENVIROMENT == .develop{
            self.urlPath = "https://apigateway.superappbaz.com/"
            self.strPathEndpoint = "integracion/superapp/prestamos/tarjeta-credito/v1/tarjetas/movimientos/busquedas"
        }else{
            self.strPathEndpoint = "/superapp/prestamos/tarjeta-credito/v1/tarjetas/movimientos/busquedas"
        }
        
        sendRequest(strUrl: strPathEndpoint, method: .POST, arrHeaders: [], objBody: Body, environment: GLOBAL_ENVIROMENT) { (objRes: GenericRawCreditCardMovementsResponse?, error) in
            debugPrint(objRes ?? "")
            
            let response = objRes?.body
            if error.code == 0 {
                CreditCardMovements(response)
            } else {
                CreditCardMovements(nil)
                debugPrint(error)
            }
        }
    }
}


