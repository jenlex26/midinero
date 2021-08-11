//
//  GSSARequestDebitCardPresenter.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 28/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSARequestDebitCardPresenter: GSSARequestDebitCardPresenterProtocol {
    weak private var view: GSSARequestDebitCardViewProtocol?
    var interactor: GSSARequestDebitCardInteractorProtocol?
    private let router: GSSARequestDebitCardWireframeProtocol

    init(interface: GSSARequestDebitCardViewProtocol, interactor: GSSARequestDebitCardInteractorProtocol?, router: GSSARequestDebitCardWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func requestGetShippingCost(Response: @escaping (PhysicalCardShippingAmountResponse?) -> ()){
        interactor?.tryGetShippingCost(Response: Response)
    }
    
    func requestCard(commission: String,  Response: @escaping () -> ()){
        interactor?.tryRequestCard(commission: commission, Response: Response)
    }
}
