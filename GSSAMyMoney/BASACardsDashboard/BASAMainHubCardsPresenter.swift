//
//  BASAMainHubCardsPresenter.swift
//  GSSAFront
//
//  Created Desarrollo on 17/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class BASAMainHubCardsPresenter: BASAMainHubCardsPresenterProtocol {
    weak private var view: BASAMainHubCardsViewProtocol?
    var interactor: BASAMainHubCardsInteractorProtocol?
    private let router: BASAMainHubCardsWireframeProtocol

    init(interface: BASAMainHubCardsViewProtocol, interactor: BASAMainHubCardsInteractorProtocol?, router: BASAMainHubCardsWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

    func requestBalance(Account:[String:String], Balance: @escaping (BalanceResponse?) -> ()){
        interactor?.TryGetDebitCardBalance(Account: Account, Balance: Balance)
    }
    
    func requestDebitCardMovementsV2(Body: MovimientosBodyv2, Movements: @escaping (DebitCardTransactionV2?) -> ()) {
        interactor?.TryGetDebitCardMovementsV2(Body: Body, Movements: Movements)
    }
    
    func requestUserLends(Lends: @escaping (LendsResponse?) -> ()){
        interactor?.tryGetUserLends(Lends: Lends)
    }
    
    func requestCreditCardNumber(CardInfoResponse: @escaping (CreditCardInfoResponse?) -> ()){
        interactor?.tryGetCreditCardNumber(CardInfoResponse: CardInfoResponse)
    }
    
    func requestCreditCardData(Body: CreditCardBody, CreditCardData: @escaping (CreditCardResponse?) -> ()){
        interactor?.tryGetCreditCardData(Body: Body, CreditCardData: CreditCardData)
    }

    func requestCreditCardBalance(Body: CreditCardBalanceBody, CreditCardBalance: @escaping (CreditCardBalanceResponse?) -> ()){
        interactor?.tryGetCreditCardBalance(Body: Body, CreditCardBalance: CreditCardBalance)
    }
    
    func requestCreditCardMovements(Body: CreditCardMovementsBody, CreditCardMovements: @escaping (CreditCardMovementsResponse?) -> ()){
        interactor?.tryGetCreditCardMovements(Body: Body, CreditCardMovements: CreditCardMovements)
    }
    
    func requestCreditCardContract(CardNumber: String, CreditCardContract: @escaping (CreditCardContractResponde?) -> ()){
        interactor?.tryGetCreditCardContract(CardNumber: CardNumber, CreditCardContract: CreditCardContract)
    }
    
}
