//
//  GSSAActivateCreditCardViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 31/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualTemplates
import GSSAVisualComponents

class GSSAActivateCreditCardViewController: UIViewController, GSSAActivateCreditCardViewProtocol, GSVTDigitalSignDelegate {
	var presenter: GSSAActivateCreditCardPresenterProtocol?

    @IBOutlet weak var txtCVV       : GSVCTextField!
    @IBOutlet weak var infoView     : UIView!
    @IBOutlet weak var nipInfoView  : UIView!
    
	override func viewDidLoad() {
        super.viewDidLoad()
        setBackButtonForOlderDevices(tint: .purple)
        hideKeyboardWhenTappedAround()
        txtCVV.delegate = self
        txtCVV.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.txtCVV.isSecureTextEntry = !selected
        })
        if #available(iOS 13.0, *){()}else{
            txtCVV.image = UIImage(named: "openEye", in: Bundle.init(for: GSSAFundSetCVVViewController.self), compatibleWith: nil)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) ?? UIImage()
            txtCVV.imageTyped = UIImage(named: "closedEye", in: Bundle.init(for: GSSAFundSetCVVViewController.self), compatibleWith: nil)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) ?? UIImage()
            txtCVV.tintColor = UIColor.GSVCSecundary100
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.txtCVV.becomeFirstResponder()
    }
    
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) {()}
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        UIWindow.addSuccess {
            let spaceView = UIView()
            spaceView.bounds = self.infoView.bounds
            
            let info = self.infoView
            info?.isHidden = false
            
            let card = self.nipInfoView
            card?.isHidden = false
            
            let button = GSVCButton()
            button.setTitle("Ver NIP", for: .normal)
            button.style = 10
            button.setImage(UIImage(named: "ic_card"), for: .normal)
            let success = GSVTOperationStatusViewController(status: .success(title: "¡Listo!", message: "Tu tarjeta baz ya está activa", views: [spaceView, info!, card!]),
                                                            roundButtonAction: {
                                                                self.dismiss(animated: false, completion: nil)
                                                            },
                                                            plainButtonAction: {
                                                                self.dismiss(animated: false, completion: {
                                                                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                                                                    for VC in viewControllers{
                                                                        if VC is BASACardConfigViewController{
                                                                            self.navigationController?.popToViewController(VC, animated: true)
                                                                        }
                                                                    }
                                                                })
                                                            },
                                                            roundButton: button)
            success.modalPresentationStyle = .overCurrentContext
            self.present(success, animated: true, completion: nil)
        }
    }
    
    @IBAction func next(_ sender: Any){
        let verification = GSVTDigitalSignViewController(delegate: self)
        verification.bShouldWaitForNewToken = false
        verification.modalPresentationStyle = .overCurrentContext
        self.present(verification, animated: true, completion: nil)
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

extension GSSAActivateCreditCardViewController: UITextFieldDelegate{

}
