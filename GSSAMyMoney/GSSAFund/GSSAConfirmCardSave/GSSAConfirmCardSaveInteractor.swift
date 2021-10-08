//
//  GSSAConfirmCardSaveInteractor.swift
//  GSSAMyMoney
//
//  Created Usuario Phinder 2021 on 02/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import baz_ios_sdk_link_pago
import GSSASessionInfo

class GSSAConfirmCardSaveInteractor{
    weak var presenter: GSSAConfirmCardSavePresenterProtocol?
    private let afiliationNumber: String? = GSSAFundSharedVariables.shared.numeroAfiliacion
    private let email = GSSISessionInfo.sharedInstance.gsUser.email?.lowercased()
}

extension GSSAConfirmCardSaveInteractor: GSSAConfirmCardSaveInteractorProtocol {


    func getEccomerceInformation() {
        //self.requestEcommerceSMMInformation()
        guard let afiliationNumber = afiliationNumber else {
            self.presenter?.getEccomerceInformationError()
            return
        }

        LNKPG_Facade.shared.Initialize(environment: .release)
        LNKPG_Facade.shared.getEcommerceInformation(numeroAfiliacion: afiliationNumber, success: { [weak self] response in
            guard let self = self else { return }

            guard let response = response else {
                self.presenter?.getEccomerceInformationError()
                return
            }

            GSSAFundSharedVariables.shared.ecommerceResponse = response
            
            self.requestEcommerceSMMInformation()
        
            //self.presenter?.getEccomerceSMMInformationSuccess()
            
            
        }, failure: {  [weak self] message in
            guard let self = self else { return }

            //print("Message Error: \(message ?? "")")
            self.presenter?.getEccomerceInformationError()
        })
    }
    
    private func requestEcommerceSMMInformation(){
        guard let email = email,
              let afiliationNumber = afiliationNumber else {
            self.presenter?.getEccomerceInformationError()
            return
        }
        
        LNKPG_Facade.shared.getEcommerceSMMInformation(numeroAfiliacion: afiliationNumber, email: email) { [weak self] (information) in
            guard let self = self else { return }

            if let response = information {
                GSSAFundSharedVariables.shared.ecommerceSMMIResponse = response
            }
            guard let _ = information else {
                self.presenter?.getEccomerceInformationError()
                return
            }
            self.presenter?.getEccomerceSMMInformationSuccess()
        } failure: {
            [weak self] message in
            guard let self = self else { return }
            self.presenter?.getEccomerceInformationError()
        }
    }
    
    func requestSaveCard(tokenCardRequest: LNKPG_TokenCardRequestFacade) {
        //print(tokenCardRequest)
        LNKPG_Facade.shared.postCreateToken(token: tokenCardRequest) {[weak self] response in
            guard let self = self else  { return }
            //print("\n\n##############\n\(response)\n################\n\n")
            if let response = response {
                if let createdCardToken = response.paySubscriptionId {
                    LNKPG_Facade.shared.getListCard(numeroAfiliacion: GSSAFundSharedVariables.shared.numeroAfiliacion ?? "", email: (GSSISessionInfo.sharedInstance.gsUser.email ?? "").lowercased()) { tokens in
                        if let nonNilTokens = tokens {
                            for token in nonNilTokens {
                                if createdCardToken == token.token ?? ""{
                                    if !(token.activo ?? false) {
                                        self.presenter?.onErrorTokenNoActivo()
                                        return
                                    }
                                }
                            }
                            self.presenter?.onSuccess(response)
                        }
                    } failure: { error in
                        self.presenter?.onError()
                        return
                    }
                }else{
                    self.presenter?.onError()
                }
            } else {
                self.presenter?.onError()
            }
            
        } failure: { [weak self] error in
            guard let self = self else  { return }
            
            //print(error)
            self.presenter?.onError()
        }
    }
}
