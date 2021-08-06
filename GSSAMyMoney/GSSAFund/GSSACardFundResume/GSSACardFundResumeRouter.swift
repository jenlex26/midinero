//
//  GSSACardFundResumeRouter.swift
//  GSSAMyMoney
//
//  Created Usuario Phinder 2021 on 03/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit


class GSSACardFundResumeRouter: GSSACardFundResumeWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = GSSACardFundResumeViewController(nibName: nil, bundle: Bundle.init(for: GSSAConfirmCardSaveRouter.self))
        let interactor = GSSACardFundResumeInteractor()
        let router = GSSACardFundResumeRouter()
        let presenter = GSSACardFundResumePresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}