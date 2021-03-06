//
//  GSSAFundSharedVariables.swift
//  GSSAFund
//
//  Created by Branchbit on 04/08/21.
//

import Foundation
import baz_ios_sdk_link_pago

class GSSAFundSharedVariables {
    static let shared = GSSAFundSharedVariables()
    
    let currencyCode = "MXN"
    
    var ecommerceResponse: LNKPG_EcommerceResponseFacade?
    var ecommerceSMMIResponse: LNKPG_ESM_MovementsResponseFacade?
    var ecommerceSMTIResponse: LNKPG_ESM_TransactionsResponseFacade?
    var cardListResponse: LNKPG_ListCardResponseFacade?
    var cardInformationResponse: LNKPG_CardInformationResponseFacade?
    var tokenCardResponse: LNKPG_TokenCardResponseFacade?
    var countriesResponse: LNKPG_CountriesResponseFacade?
    var countryStatesResponse: LNKPG_CountryStatesResponseFacade?
    var enrollmentResponse: LNKPG_EnrollmentResponseFacade?
    var sessionOTPResponse: LNKPG_SessionOTPResponseFacade?
    var sessionOTPV2Response: LNKPG_SessionOTPV2ResponseFacade?
    var authValidateResponse: LNKPG_AuthValidateResponseFacade?
    var fondeoAccountResponse: LNKPG_FondeoAccountResponseFacade?
    var cargoEcommerceResponse: LNKPG_CargoEcommerceResponseFacade?
    var enrollmentRequest: LNKPG_EnrollmentRequestFacade?
    var createTokenRequest: LNKPG_TokenCardRequestFacade?
    var cardInformation: LNKPG_CardInformationFacade?
    
    var cvv: String?
    var cardCount: Int?
    var amount: String?
    var transactionComission: String?
    var transactionAmountPlusComission: Double?
    var merchantDetail: String?
    var numeroAfiliacion: String?
    var clientAccountNumber: String?
    var idTransaccionSuperApp: String?
    
    func randomString(length: Int) -> String {
        let letters = "0123456789abcdefghijklmnopqrstuvwxyz"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func getIdTransactionSuperApp () -> String{
        self.idTransaccionSuperApp = "ios\(self.randomString(length: 17))"
        return self.idTransaccionSuperApp!
    }
    
    func getCardName(cardNumer: String) -> String {
        return cardNumer.first == "4" ? "Visa" : cardNumer.first == "5" ? "Mastercard" : "000"
    }
    
    func getCardType(cardNumer: String) -> String{
        return cardNumer.first == "4" ? "001" : cardNumer.first == "5" ? "002" : "000"
    }
    
    func resetSingleton(){
        self.ecommerceResponse = nil
        self.ecommerceSMMIResponse = nil
        self.ecommerceSMTIResponse = nil
        self.cardListResponse = nil
        self.cardInformationResponse = nil
        self.tokenCardResponse = nil
        self.countriesResponse = nil
        self.countryStatesResponse = nil
        self.enrollmentResponse = nil
        self.sessionOTPResponse = nil
        self.sessionOTPV2Response = nil
        self.authValidateResponse = nil
        self.fondeoAccountResponse = nil
        self.cargoEcommerceResponse = nil
        self.enrollmentRequest = nil
        self.createTokenRequest = nil
        self.cardInformation = nil
        
        self.cardCount = nil
        self.amount = nil
        self.transactionComission = nil
        self.transactionAmountPlusComission = nil
        self.merchantDetail = nil
        self.clientAccountNumber = nil
        self.numeroAfiliacion = nil
        self.cvv = nil
        self.idTransaccionSuperApp = nil
    }
    
    /*
     merchantdetail
     numerocuentacliente
     numeroafiliacion
     */
}
