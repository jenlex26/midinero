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

class GSSALinkDePagoViewController: GSSAMasterViewController, GSSALinkDePagoViewProtocol, GSVCBottomAlertHandler, GSVTDigitalSignDelegate {
    
    var bottomAlert: GSVCBottomAlert?
    var presenter: GSSALinkDePagoPresenterProtocol?
    
    @IBOutlet weak var txtMail  : GSVCTextField!
    @IBOutlet weak var txtAmount: GSVCTextField!
    @IBOutlet weak var lblMail  : GSVCLabel!
    @IBOutlet weak var lineView : UIView!
    
    var close: Bool? = false
    var hasNav: Bool?
    let textTest = UITextField()
    var startTime: Date?
    var time: TimeInterval = 300.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMail.delegate = self
        txtMail.returnKeyType = .done
        txtAmount.returnKeyType = .next
        txtAmount.text = "$0.00"
        txtAmount.addTarget(self, action: #selector(ammountFormatter(sender:)), for: .editingChanged)
        setUpToolBar()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Recarga tu tarjeta"
        
        if GSSISessionInfo.sharedInstance.gsUser.email?.isValidEmail == true{
            lblMail.isHidden = true
            txtMail.isHidden = true
            lineView.isHidden = true
        }else{
            lblMail.isHidden = false
            txtMail.isHidden = false
            lineView.isHidden = false
        }
        
        if hasNav != true && close == false{
            startTime = Date()
            checkTime()
            txtAmount.addTarget(self, action: #selector(activityObserve), for: .editingChanged)
            let verification = GSVTDigitalSignViewController(delegate: self)
            verification.modalPresentationStyle = .fullScreen
            verification.bShouldWaitForNewToken = false
            present(verification, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GSVCLoader.hide()
        if hasNav == true{
            txtAmount.becomeFirstResponder()
        }
        createTag(eventName: .pageView, section: "mi_dinero", flow: "fondear_cuenta", screenName: "monto", origin: "")
        setProgressLine(value: 0.25, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        activityObserve()
    }
    
    @objc func ammountFormatter(sender: UITextField){
        if sender.text!.count < 9{
            var number: NSNumber!
            let formatter = NumberFormatter()
            formatter.numberStyle = .currencyAccounting
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            
            var amountWithPrefix = sender.text
            let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
            amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0,  sender.text!.count), withTemplate: "")
            
            let double = (amountWithPrefix! as NSString).doubleValue
            number = NSNumber(value: (double / 100))
            guard number != 0 as NSNumber else {
                sender.text = ""
                return
            }
            sender.text = formatter.string(from: number)!
        }else{
            sender.text?.removeLast()
        }
    }
    
    @objc func doneButtonClick(){
        self.view.endEditing(true)
    }
    
    func checkTime(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [self] in
            if (self.startTime! + time) < Date(){
                self.dismiss(animated: true, completion: nil)
            }else{
                self.checkTime()
            }
        })
    }
    
    @objc func activityObserve(){
        startTime = Date()
        time = 300.0
    }
    
    func setUpToolBar(){
        let buttonTwo =  UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(doneButtonClick))
        buttonTwo.tintColor = .white
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.backgroundColor = UIColor(red: 19/255, green: 49/255, blue: 219/255, alpha: 1.0)
        numberToolbar.barTintColor = UIColor.GSVCPrincipal100
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), buttonTwo]
        numberToolbar.sizeToFit()
        txtAmount.inputAccessoryView = numberToolbar
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
        
        self.navigationController?.pushViewController(GSSAFundSelectCardRouter.createModule(loadingModel: validado!), animated: true)
        
        //        self.present(view, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(view, animated: true)
    }
    
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) {
        print("forgot")
    }
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        txtAmount.becomeFirstResponder()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtMail{
            if self.view.frame.origin.y < 100.0 {
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.view.frame.origin.y -= 100.0
                })
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtMail{
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame.origin.y += 100.0
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
