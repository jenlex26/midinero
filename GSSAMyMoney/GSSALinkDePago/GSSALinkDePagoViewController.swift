//
//  GSSALinkDePagoViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 12/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualTemplates
import GSSAVisualComponents
import GSSASessionInfo
import GSSAFunctionalUtilities
import GSSAFirebaseManager
import baz_ios_sdk_link_pago

class GSSALinkDePagoViewController: UIViewController, GSSALinkDePagoViewProtocol, GSVCBottomAlertHandler, GSVTDigitalSignDelegate {
    
    var bottomAlert: GSVCBottomAlert?
    var presenter: GSSALinkDePagoPresenterProtocol?
    
    @IBOutlet weak var txtMail: GSVCTextField!
    @IBOutlet weak var txtAmount: GSVCTextField!
    @IBOutlet weak var lblMail: GSVCLabel!
    @IBOutlet weak var navBar: UIView!
    var close: Bool? = false
    var hasNav: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.GSVCPrincipal100
        self.navBar.backgroundColor = UIColor.GSVCPrincipal100
        txtMail.delegate = self
        txtMail.returnKeyType = .done
        txtAmount.returnKeyType = .next
        txtAmount.delegate = self
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        if GSSISessionInfo.sharedInstance.gsUser.email?.isValidEmail == true{
            lblMail.isHidden = true
            txtMail.isHidden = true
        }else{
            lblMail.isHidden = false
            txtMail.isHidden = false
        }
        
        if hasNav != true && close == false{
            let verification = GSVTDigitalSignViewController(delegate: self)
            verification.modalPresentationStyle = .fullScreen
            verification.bShouldWaitForNewToken = false
            present(verification, animated: true, completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtAmount.becomeFirstResponder()
        createTag(eventName: .pageView, section: "mi_dinero", flow: "fondear_cuenta", screenName: "monto", origin: "")
        if close == true{
            if hasNav == true{
                self.navigationController?.popViewController(animated: false)
            }else{
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func optionalAction() {
        print("Ok")
    }
    
    func isValidAmount() -> Bool{
        if txtAmount.text?.haveData() == true{
            let quantity = Double(txtAmount.text?.moneyToDoubleString() ?? "0") ?? 0
            if quantity > 0.0 && quantity <= 2500.0{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    func showFondeo(){
        let quantity = txtAmount.text?.moneyToDoubleString()
        var mail = GSSISessionInfo.sharedInstance.gsUser.email
        if mail?.haveData() == false || mail == nil{
            mail = txtMail.text
        }
        let accountNumber = GSSISessionInfo.sharedInstance.gsUser.mainAccount?.formatToTnuocca14Digits().encryptAlnova()
        
        let parameters = [
            "amount": "\(quantity ?? "0.0")",
            "numeroCuentaCliente": "\(accountNumber ?? "")",
            "merchantDetail":"Abono Saldo", "correo": "\(mail ?? "")",
            "numeroAfiliacion": "8632464"
        ]
        
        let validado = GSSALinkDePagoViewController.validateStrings(parameters: parameters)
        let view = PB_HomeMain.createModule(loadingModel: validado!)
        view.modalPresentationStyle = .fullScreen
        close = true
        self.present(view, animated: true, completion: nil)
        //self.navigationController?.pushViewController(view, animated: true)
    }
    
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) {
        print("forgot")
    }
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        print("Ok")
    }
    
    func cancelDigitalSing(_ isUserBlocked: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public static func validateStrings(parameters: [String : Any]?) -> PB_HomeEntity? {
        guard let amount: String = parameters?["amount"] as? String else { debugPrint("Falta Campo amount"); return nil }
        guard let numeroCuentaCliente: String = parameters?["numeroCuentaCliente"] as? String else { debugPrint("Falta Campo numeroCuentaCliente"); return nil }
        guard let merchantDetail: String = parameters?["merchantDetail"] as? String else { debugPrint("Falta Campo merchantDetail"); return nil }
        guard let correo: String = parameters?["correo"] as? String else { debugPrint("Falta Campo correo"); return nil }
        guard let numeroAfiliacion: String = parameters?["numeroAfiliacion"] as? String else { debugPrint("Falta Campo numeroAfiliacion"); return nil }
        return PB_HomeEntity(
            amount: amount,
            numeroAfiliacion: numeroAfiliacion,
            numeroCuentaCliente: numeroCuentaCliente,
            merchantDetail: merchantDetail,
            correo: correo,
            idTransaccion: "")
    }
    
    @IBAction func close(sender: GSVCButton){
        if hasNav == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func next(sender: GSVCButton){
        if txtMail.isHidden == false && txtMail.text?.isValidEmail ==  true{
            if isValidAmount() == true{
                let quantity = Double(txtAmount.text?.moneyToDoubleString() ?? "0.0") ?? 0.0
                if quantity > 2500.0{
                    self.presentBottomAlertFullData(status: .error, message: "Ingrese una cantidad menor o igual a $2,500.00", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
                }else{
                    GSVCLoader.show()
                    presenter?.requestMailUpdate(body: UpdateMailBody.init(correoElectronico: txtMail.text?.encryptAlnova()), Response: { Response in
                        GSVCLoader.hide()
                        if Response != nil{
                            self.showFondeo()
                        }else{
                            self.showFondeo()
                        }
                    })
                }
            }else{
                self.presentBottomAlertFullData(status: .error, message: "Ingrese una cantidad menor o igual a $2,500", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            }
        }else if isValidAmount() == true && txtMail.isHidden == true{
            showFondeo()
        }else if txtMail.isHidden == false{
            self.presentBottomAlertFullData(status: .error, message: "Ingrese un correo electrónico válido", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
        }else{
            self.presentBottomAlertFullData(status: .error, message: "Ingrese una cantidad menor o igual a $2,500", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
        }
    }
}

extension GSSALinkDePagoViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtMail{
            self.view.endEditing(true)
        }
        if textField == txtAmount{
            if txtMail.isHidden == true{
                self.view.endEditing(true)
            }else{
                textField.resignFirstResponder()
                txtMail.becomeFirstResponder()
            }
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtAmount{
            let hasLittleCoin = false
            
            if string.count == 0, txtAmount.text?.dValue ?? 0 < 0.1 {
                textField.resetAmount(withLittleCoin: hasLittleCoin)
            } else {
                let bHideCents = GSSISessionInfo.sharedInstance.bHideCents
                
                textField.addText(newText: string,
                                  withMaxFontSize: 38,
                                  withLittleCoin: hasLittleCoin, withFontWeight: .bold,
                                  withNoDecimals: bHideCents)
            }
            return false
        }else{
            return true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtMail{
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame.origin.y -= 100.0
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtMail{
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame.origin.y = 0.0
            })
        }
        if textField == txtAmount{
            if txtMail.isHidden == false{
                txtMail.becomeFirstResponder()
            }else{
                self.view.endEditing(true)
            }
        }
    }
}
