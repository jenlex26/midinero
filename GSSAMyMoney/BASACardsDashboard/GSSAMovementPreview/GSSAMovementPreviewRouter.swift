//
//  GSSAMovementPreviewRouter.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 13/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSAMovementPreviewRouter: GSSAMovementPreviewWireframeProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule(item: DebitCardTransactionItem) -> UIViewController {
        let view = GSSAMovementPreviewViewController(nibName: "GSSAMovementPreviewViewController", bundle: Bundle(for: GSSAMovementPreviewRouter.self))
        let interactor = GSSAMovementPreviewInteractor()
        let router = GSSAMovementPreviewRouter()
        let presenter = GSSAMovementPreviewPresenter(interface: view, interactor: interactor, router: router)
        
        view.data = item 
        view.presenter = presenter
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}