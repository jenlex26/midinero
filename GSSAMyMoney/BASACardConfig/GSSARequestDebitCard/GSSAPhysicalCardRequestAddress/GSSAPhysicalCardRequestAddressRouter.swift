//
//  GSSAPhysicalCardRequestAddressRouter.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 29/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSAPhysicalCardRequestAddressRouter: GSSAPhysicalCardRequestAddressWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = GSSAPhysicalCardRequestAddressViewController(nibName: nil, bundle: Bundle.init(for: GSSAPhysicalCardRequestAddressRouter.self))
        let interactor = GSSAPhysicalCardRequestAddressInteractor()
        let router = GSSAPhysicalCardRequestAddressRouter()
        let presenter = GSSAPhysicalCardRequestAddressPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
