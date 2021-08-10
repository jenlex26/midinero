//
//  GSSASetCVVViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 29/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates

class GSSASetCVVViewController: GSSAMasterViewController, GSSASetCVVViewProtocol, UITextFieldDelegate{
    
    var presenter: GSSASetCVVPresenterProtocol?
    
    @IBOutlet weak var txtCVV       : GSVCTextField!
    @IBOutlet weak var infoView     : UIView!
    @IBOutlet weak var cardInfoView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Activa tu tarjeta"
        txtCVV.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setProgressLine(value: 0.5, animated: true)
        txtCVV.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 3
    }
    
    @IBAction func next(_ sender: Any){
        UIWindow.addSuccess {
            let spaceView = UIView()
            spaceView.bounds = self.infoView.bounds
            
            let info = self.infoView
            info?.isHidden = false
            
            let card = self.cardInfoView
            card?.isHidden = false
            
            let button = GSVCButton()
            button.setTitle("Ver NIP", for: .normal)
            button.style = 10
            if #available(iOS 13.0, *) {
                button.setImage(UIImage(named: "ic_card"), for: .normal)
            }
            let success = GSVTOperationStatusViewController(status: .success(title: "¡Listo!", message: "Tu tarjeta baz ya está activa", views: [spaceView, info!, card!]),
                                                            roundButtonAction: {
                                                                self.dismiss(animated: false, completion: {
                                                                    let view = GSSACardNIPRouter.createModule()
                                                                    self.navigationController?.pushViewController(view, animated: true)
                                                                })
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
            success.modalPresentationStyle = .fullScreen
            self.present(success, animated: true, completion: nil)
        }
    }
}
