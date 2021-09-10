//
//  BASACardConfigPresenter.swift
//  TEST3
//
//  Created Desarrollo on 13/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class BASACardConfigPresenter: BASACardConfigPresenterProtocol {

    weak private var view: BASACardConfigViewProtocol?
    var interactor: BASACardConfigInteractorProtocol?
    private let router: BASACardConfigWireframeProtocol

    init(interface: BASACardConfigViewProtocol, interactor: BASACardConfigInteractorProtocol?, router: BASACardConfigWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func requestCardStatus(CardSearchResponse: @escaping (CardStatusResponse?) -> ()){
        interactor?.tryGetRequestedCardStatus(CardSearchResponse: CardSearchResponse)
    }
    
    func requestCardInfo(DebitCardInfoResponse: @escaping (DebitCardInfoResponse?) -> ()){
        interactor?.tryGetRequestCardInfo(DebitCardInfoResponse: DebitCardInfoResponse)
    }

}
