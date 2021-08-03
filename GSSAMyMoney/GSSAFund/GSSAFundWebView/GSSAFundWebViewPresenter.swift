//
//  GSSAFundWebViewPresenter.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 03/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSAFundWebViewPresenter: GSSAFundWebViewPresenterProtocol {

    weak private var view: GSSAFundWebViewViewProtocol?
    var interactor: GSSAFundWebViewInteractorProtocol?
    private let router: GSSAFundWebViewWireframeProtocol

    init(interface: GSSAFundWebViewViewProtocol, interactor: GSSAFundWebViewInteractorProtocol?, router: GSSAFundWebViewWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }

}
