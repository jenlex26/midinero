//
//  BASAMainHubCardsProtocols.swift
//  GSSAFront
//
//  Created Andoni Suarez Martinez on 17/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol BASAMainHubCardsWireframeProtocol: AnyObject {

}
//MARK: Presenter -
protocol BASAMainHubCardsPresenterProtocol: AnyObject {
    func requestBalance(Account:[String:String], Balance: @escaping (BalanceResponse?) -> ())
    func requestDebitCardMovementsV2(Body: MovimientosBodyv2, Movements: @escaping (DebitCardTransactionV2?) -> ()) 
    func requestUserLends(Lends: @escaping (LendsResponse?) -> ())
    func requestCreditCardNumber(CardInfoResponse: @escaping (CreditCardInfoResponse?) -> ())
    func requestCreditCardData(Body: CreditCardBody, CreditCardData: @escaping (CreditCardResponse?) -> ())
    func requestCreditCardBalance(Body: CreditCardBalanceBody, CreditCardBalance: @escaping (CreditCardBalanceResponse?) -> ())
    func requestCreditCardMovements(Body: CreditCardMovementsBody, CreditCardMovements: @escaping (CreditCardMovementsResponse?) -> ())
    func requestCreditCardContract(CardNumber: String, CreditCardContract: @escaping (CreditCardContractResponde?) -> ())
}

//MARK: Interactor -
protocol BASAMainHubCardsInteractorProtocol: AnyObject {
  var presenter: BASAMainHubCardsPresenterProtocol?  { get set }
    func TryGetDebitCardBalance(Account:[String:String], Balance: @escaping (BalanceResponse?) -> ())
    func TryGetDebitCardMovementsV2(Body: MovimientosBodyv2, Movements: @escaping (DebitCardTransactionV2?) -> ())
    func tryGetUserLends(Lends: @escaping (LendsResponse?) -> ())
    func tryGetCreditCardNumber(CardInfoResponse: @escaping (CreditCardInfoResponse?) -> ())
    func tryGetCreditCardData(Body: CreditCardBody, CreditCardData: @escaping (CreditCardResponse?) -> ())
    func tryGetCreditCardBalance(Body: CreditCardBalanceBody, CreditCardBalance: @escaping (CreditCardBalanceResponse?) -> ())
    func tryGetCreditCardMovements(Body: CreditCardMovementsBody, CreditCardMovements: @escaping (CreditCardMovementsResponse?) -> ())
    func tryGetCreditCardContract(CardNumber: String, CreditCardContract: @escaping (CreditCardContractResponde?) -> ())
}

//MARK: View -
protocol BASAMainHubCardsViewProtocol: AnyObject {
  var presenter: BASAMainHubCardsPresenterProtocol?  { get set }
}
