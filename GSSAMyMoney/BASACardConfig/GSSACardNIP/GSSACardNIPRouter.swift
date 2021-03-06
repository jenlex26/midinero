//
//  GSSACardNIPRouter.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 30/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSACardNIPRouter: GSSACardNIPWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(cvv: String, contractNumber: String) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = GSSACardNIPViewController(nibName: nil, bundle: Bundle.init(for: GSSACardNIPRouter.self))
        let interactor = GSSACardNIPInteractor()
        let router = GSSACardNIPRouter()
        let presenter = GSSACardNIPPresenter(interface: view, interactor: interactor, router: router)
        
        view.CVV = cvv
        view.contractNumber = contractNumber
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
