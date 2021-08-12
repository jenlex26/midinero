//
//  File.swift
//  BASAMyPayments
//
//  Created by Benigno Marin Mendoza on 03/06/21.
//

import UIKit

class BASAScanCodePresenter: BASAScanCodePresenterProtocol {
    weak private var view: BASAScanCodeViewProtocol?
    var interactor: BASAScanCodeInteractorProtocol?
    private let router: BASAScanCodeWireframeProtocol

    init(interface: BASAScanCodeViewProtocol?, interactor: BASAScanCodeInteractorProtocol?, router: BASAScanCodeWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func codeDetected(sCode: String) {
        router.codeDetectedRouter(sCode: sCode)
    }
    func cancelCodeScanner() {
        router.cancelCodeScanner()
    }
}
