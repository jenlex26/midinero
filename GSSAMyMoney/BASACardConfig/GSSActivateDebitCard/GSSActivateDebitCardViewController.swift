//
//  GSSActivateDebitCardViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 29/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit

class GSSActivateDebitCardViewController: GSSAMasterViewController, GSSActivateDebitCardViewProtocol
  {

	var presenter: GSSActivateDebitCardPresenterProtocol?

	override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Activa tu tarjeta"
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setProgressLine(value: 0.25, animated: true)
    }
    
    @IBAction func next(_ sender: Any){
        let scanScreen = BASAScanCodeRouter.createModule(secuence: .scanCarCode, delegate: self)
        if let nav = self.navigationController{
            nav.present(scanScreen, animated: true, completion: nil)
        }
    }
}


extension GSSActivateDebitCardViewController : BASAScanCodeWireframeProtocol {
    func codeDetectedRouter(sCode: String) {
        let view = GSSASetCVVRouter.createModule(cardNumber: sCode)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func cancelCodeScanner() {()}
}
