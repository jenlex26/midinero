//
//  GSSAAddFundsMenuRouter.swift
//  GSSAMyMoney
//
//  Created Andoni Suarez  on 18/10/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSAAddFundsMenuRouter: GSSAAddFundsMenuWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = GSSAAddFundsMenuViewController(nibName: nil, bundle: Bundle.init(for: GSSAAddFundsMenuRouter.self))
        let interactor = GSSAAddFundsMenuInteractor()
        let router = GSSAAddFundsMenuRouter()
        let presenter = GSSAAddFundsMenuPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
