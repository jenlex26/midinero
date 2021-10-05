//
//  GSSAFundWebViewInteractor.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 03/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import baz_ios_sdk_link_pago

class GSSAFundWebViewInteractor: GSSAFundWebViewInteractorProtocol {

    weak var presenter: GSSAFundWebViewPresenterProtocol?
    
    func checkFund() {
        guard let enrollmentID = GSSAFundSharedVariables.shared.enrollmentResponse?.payer?.xid else {
            presenter?.onError(content: nil)
            return
        }
        
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "showLoading"), object: nil, userInfo: nil))
        
        LNKPG_Facade.shared.getSessionOTP(sessionOTPV2Request: LNKPG_SessionOTPV2RequestFacade(idInscripcion: enrollmentID)) { [weak self] response in
            guard let self = self else { return }
            
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "showLoading"), object: nil, userInfo: nil))
       
            guard let merchantID = GSSAFundSharedVariables.shared.ecommerceResponse?.comerciosCybs?.id,
                  let merchantReference = GSSAFundSharedVariables.shared.idTransaccionSuperApp,
                  let amount = GSSAFundSharedVariables.shared.transactionAmountPlusComission /*GSSAFundSharedVariables.shared.amount*/,
                  //let card = GSSAFundSharedVariables.shared.cardInformationResponse?.card,
                  let card = GSSAFundSharedVariables.shared.cardInformation?.card,
                  
                  let cardNumber = card.number, let expirationMonth = card.expirationMonth, let expirationYear = card.expirationYear,
                  let type = card.type else {
                
                self.presenter?.onError(content: nil)
                return
            }
            
            
            let currencyCode = GSSAFundSharedVariables.shared.currencyCode
            
            let authValidateRequestFacade = LNKPG_AuthValidateRequestFacade(merchantID: merchantID, merchantReference: merchantReference, amount: String(amount), payerAuthenticationResult: response?.resultadoAutenticacionPagador ?? "Dummy", transactionCurrencyCode: currencyCode, card: LNKPG_AuthValidateRequestFacade.__card(number: cardNumber, expirationMonth: expirationMonth, expirationYear: expirationYear, type: type))
            
            LNKPG_Facade.shared.postAuthValidate(authValidateRequest: authValidateRequestFacade) { [weak self] response in
                guard let self = self else { return }
                
                guard let response = response,
                      let numeroCuenta = GSSAFundSharedVariables.shared.clientAccountNumber,
                      let ecommerceResponse = GSSAFundSharedVariables.shared.ecommerceResponse,
                      let cardInformation = GSSAFundSharedVariables.shared.cardInformation,
                      let enrollmentResponse = GSSAFundSharedVariables.shared.enrollmentResponse,
                      let cvv = GSSAFundSharedVariables.shared.cvv,
                      let merchantReference = GSSAFundSharedVariables.shared.idTransaccionSuperApp,
                      let amount = GSSAFundSharedVariables.shared.transactionAmountPlusComission /*GSSAFundSharedVariables.shared.amount*/ else {
                    
                    self.presenter?.onError(content: nil)
                    return
                }
                
                LNKPG_PaymentFacade.shared.notifyAuthValidate(authValidate: response, numeroCuentaCliente: numeroCuenta, ecommerceResponse: ecommerceResponse, cardInformation: cardInformation, enrollmentResponse: enrollmentResponse, cvv: cvv, idTransaccionSuperApp: merchantReference, monto: String(amount)) { [weak self] response in
                    guard let self = self else { return }
                    
                    guard let response = response else {
                        
                        self.presenter?.onError(content: nil)
                        return
                    }
                    
                    let folio = response.folioOperacion ?? ""
                    self.presenter?.onSucess(folio: folio)
                } successCargoEcommerceResponse: { [weak self] response in
                    guard let self = self else { return }
                    
                    guard let response = response else {
                        
                        self.presenter?.onError(content: nil)
                        return
                    }
                    
                    let folio = response.folioOperacion ?? ""
                    self.presenter?.onSucess(folio: folio)
                    
                } successSessionOTPRequest: { [weak self] response in
                    guard let self = self else { return }
                    self.checkFund()
                    
                } failure: { [weak self] error in
                    guard let self = self else { return }
                    self.presenter?.onError(content: error)
                }

            } failure: { [weak self] error in
                guard let self = self else { return }
                self.presenter?.onError(content: error)
            }
        } failure: { [weak self] error in
            guard let self = self else { return }
            self.presenter?.onError(content: error)
        }
    }
}
