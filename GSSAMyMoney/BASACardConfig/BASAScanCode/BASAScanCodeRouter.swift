//
//  File.swift
//  BASAMyPayments
//
//  Created by Benigno Marin Mendoza on 03/06/21.
//

import UIKit

open class BASAScanCodeRouter: BASAScanCodeWireframeProtocol {
    weak var viewController: UIViewController?
    weak var delegateRouter: BASAScanCodeWireframeProtocol?
    
    public static func createModule(secuence: GSSAMyMoneyScanSecuence?, delegate: BASAScanCodeWireframeProtocol) -> UIViewController {
        let view = BASAScanCodeViewController.init(with: secuence == .scanCarCode ? "Escanea el código QR" : "Escanea el código de barras" , showGallery: secuence == .scanCarCode ? true : false)
        let interactor  = BASAScanCodeInteractor()
        let router      = BASAScanCodeRouter()
        let presenter   = BASAScanCodePresenter(interface: view, interactor: interactor, router: router)
        view.secuence   = secuence
        view.presenter  = presenter
        interactor.presenter  = presenter
        router.viewController = view
        router.delegateRouter = delegate
        view.modalPresentationStyle = .fullScreen

        return view
    }
    public func codeDetectedRouter(sCode: String) {
        delegateRouter?.codeDetectedRouter(sCode: sCode)
    }
    public func cancelCodeScanner() {
        delegateRouter?.cancelCodeScanner()
    }
    
}
