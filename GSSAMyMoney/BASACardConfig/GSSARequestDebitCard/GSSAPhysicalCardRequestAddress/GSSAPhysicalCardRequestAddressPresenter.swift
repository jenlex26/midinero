//
//  GSSAPhysicalCardRequestAddressPresenter.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 29/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSAPhysicalCardRequestAddressPresenter: GSSAPhysicalCardRequestAddressPresenterProtocol {

    weak private var view: GSSAPhysicalCardRequestAddressViewProtocol?
    var interactor: GSSAPhysicalCardRequestAddressInteractorProtocol?
    private let router: GSSAPhysicalCardRequestAddressWireframeProtocol

    init(interface: GSSAPhysicalCardRequestAddressViewProtocol, interactor: GSSAPhysicalCardRequestAddressInteractorProtocol?, router: GSSAPhysicalCardRequestAddressWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func requestLocationInfo(CP: String, LocationInfo: @escaping (zipResponse?) -> ()) {
        interactor?.tryGetLocationInfo(CP: CP, LocationInfo: LocationInfo)
    }

}