//
//  GSSANewBeneficiaryAddressRouter.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 30/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSANewBeneficiaryAddressRouter: GSSANewBeneficiaryAddressWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = GSSANewBeneficiaryAddressViewController(nibName: nil, bundle: Bundle(for: GSSANewBeneficiaryAddressRouter.self))
        let interactor = GSSANewBeneficiaryAddressInteractor()
        let router = GSSANewBeneficiaryAddressRouter()
        let presenter = GSSANewBeneficiaryAddressPresenter(interface: view, interactor: interactor, router: router)
        view.modalPresentationStyle = .fullScreen
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    static func createModuleWithParams(data: BeneficiaryAddress) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = GSSANewBeneficiaryAddressViewController(nibName: nil, bundle: Bundle(for: GSSANewBeneficiaryAddressRouter.self))
        let interactor = GSSANewBeneficiaryAddressInteractor()
        let router = GSSANewBeneficiaryAddressRouter()
        let presenter = GSSANewBeneficiaryAddressPresenter(interface: view, interactor: interactor, router: router)
        view.modalPresentationStyle = .fullScreen
        view.beneficiaryData = data
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
