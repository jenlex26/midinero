//
//  GSSASetCVVRouter.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 29/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSASetCVVRouter: GSSASetCVVWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(cardNumber: String) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = GSSASetCVVViewController(nibName: nil, bundle: Bundle.init(for: GSSASetCVVRouter.self))
        let interactor = GSSASetCVVInteractor()
        let router = GSSASetCVVRouter()
        let presenter = GSSASetCVVPresenter(interface: view, interactor: interactor, router: router)
        
        view.cardNumber = cardNumber
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
