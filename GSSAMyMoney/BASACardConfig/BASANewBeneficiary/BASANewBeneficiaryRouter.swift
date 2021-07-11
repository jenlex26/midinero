//
//  BASANewBeneficiaryRouter.swift
//  GSSAFront
//
//  Created Desarrollo on 14/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class BASANewBeneficiaryRouter: BASANewBeneficiaryWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = BASANewBeneficiaryViewController(nibName: nil, bundle: Bundle(for: BASANewBeneficiaryRouter.self))
        let interactor = BASANewBeneficiaryInteractor()
        let router = BASANewBeneficiaryRouter()
        let presenter = BASANewBeneficiaryPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    static func createModuleForActiveItem(data: BeneficiaryItem, beneficiaryList: [BeneficiaryItem]) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = BASANewBeneficiaryViewController(nibName: nil, bundle: Bundle(for: BASANewBeneficiaryRouter.self))
        let interactor = BASANewBeneficiaryInteractor()
        let router = BASANewBeneficiaryRouter()
        let presenter = BASANewBeneficiaryPresenter(interface: view, interactor: interactor, router: router)
        
        view.listResponseData = beneficiaryList
        view.beneficiaryData = data
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
}
