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
    @IBOutlet weak var maxAmountLabel: GSVCLabel!
    var close: Bool? = false
    var hasNav: Bool?
    var startWithEmail = true
    let textTest = UITextField()
    var startTime: Date?
    var time: TimeInterval = 300.0
    var dailyLimit: Bool = false
    var monthlyLimit: Bool = false
    var numDailyTransactions: Int = 0
    var numMonthlyTransactions: Int = 0
    var dailyTransactionsLimit: Int = 0
    var montlyTransactionsLimit: Int = 0

    internal var comission: String = "0.00"
    
    internal var maxAmount = 0.0
    
    internal var  minAmount = 5.0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        maxAmountLabel.text = ""
        txtMail.delegate = self
        txtMail.returnKeyType = .done
        txtAmount.returnKeyType = .next
        txtAmount.text = "$0.00"
        txtAmount.addTarget(self, action: #selector(ammountFormatter(sender:)), for: .editingChanged)
        txtAmount.addTarget(self, action: #selector(onStartEdit), for: .editingDidBegin)
        setUpToolBar()
        self.navigationController?.navigationBar.backgroundColor = .white
        self.view.backgroundColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "Recarga tu tarjeta"
        if GSSISessionInfo.sharedInstance.gsUser.email?.isValidEmail == true{
            startWithEmail = true
            getEcommerceInformation()
        }else{
            startWithEmail = false
            let viewController = GSSALinkDePagoCorreoRouter.createModule(delegate: self)
            viewController.modalPresentationStyle = .fullScreen
            navigationController?.present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc private func onStartEdit(){
        bottomAlert?.animateDismissal()
        bottomAlert = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lblMail.isHidden = true
        txtMail.isHidden = true
        lineView.isHidden = true
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
    
    func optionalAction() {}
    
    func isValidAmount() -> Bool{
        if txtAmount.text?.haveData() == true{
            let quantity = Double(txtAmount.text?.moneyToDoubleString() ?? "0") ?? 0
            if quantity >= self.minAmount && quantity <= maxAmount{
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    
    func getEcommerceInformation(){
        lblMail.isHidden = true
        txtMail.isHidden = true
        lineView.isHidden = true
        GSSAFundSharedVariables.shared.numeroAfiliacion = "8632464"
        GSSAFundSharedVariables.shared.clientAccountNumber = GSSISessionInfo.sharedInstance.gsUser.account?.number?.formatToTnuocca14Digits().encryptAlnova()
        GSVCLoader.show()
        self.presenter?.getEccomerceInformation()
    }
    
    
    
    func showFondeo(){
        let quantity = txtAmount.text?.moneyToDoubleString()
        var mail = GSSISessionInfo.sharedInstance.gsUser.email
        let accountNumber = GSSISessionInfo.sharedInstance.gsUser.account?.number?.formatToTnuocca14Digits().encryptAlnova()
        let idTransaccion = GSSAFundSharedVariables.shared.getIdTransactionSuperApp()
        let parameters = [
            "amount": "\(quantity ?? "0.0")",
            "numeroCuentaCliente": "\(accountNumber ?? "")",
            "merchantDetail":"Abono Saldo", "correo": "\(mail ?? "")",
            "numeroAfiliacion": "8632464",
            "idTransaccion": idTransaccion
        ]
        
        let validado = GSSALinkDePagoViewController.validateStrings(parameters: parameters)
        let view = PB_HomeMain.createModule(loadingModel: validado!)
        view.modalPresentationStyle = .fullScreen
        close = true
        
        self.navigationController?.pushViewController(GSSAFundSelectCardRouter.createModule(loadingModel: validado!, comission: self.comission), animated: true)
    }
    
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) { () }
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        txtAmount.becomeFirstResponder()
    }
    
    func cancelDigitalSing(_ isUserBlocked: Bool) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public static func validateStrings(parameters: [String : Any]?) -> PB_HomeEntity? {
        guard let amount: String = parameters?["amount"] as? String else { return nil }
        guard let numeroCuentaCliente: String = parameters?["numeroCuentaCliente"] as? String else { return nil }
        guard let merchantDetail: String = parameters?["merchantDetail"] as? String else { return nil }
        guard let correo: String = parameters?["correo"] as? String else { return nil }
        guard let numeroAfiliacion: String = parameters?["numeroAfiliacion"] as? String else { return nil }
        guard let idTransaccion: String = parameters?["idTransaccion"] as? String else { return nil }
        return PB_HomeEntity(
            amount: amount,
            numeroAfiliacion: numeroAfiliacion,
            numeroCuentaCliente: numeroCuentaCliente,
            merchantDetail: merchantDetail,
            correo: correo,
            idTransaccion: idTransaccion)
    }
    
    @IBAction func close(sender: GSVCButton){
        if hasNav == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func showAlert() {
        activityObserved()
        
        guard dailyLimit, numDailyTransactions < dailyTransactionsLimit else {
            self.presentBottomAlertFullData(status: .error, message: "Excedió número de transacciones diarios permitidos", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            return
        }

        guard monthlyLimit, numMonthlyTransactions < montlyTransactionsLimit else {
            self.presentBottomAlertFullData(status: .error, message: "Excedió número de transacciones mensuales permitidos", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            return
        }
        
        let quantity = Double(self.txtAmount.text?.moneyToDoubleString() ?? "0.0") ?? 0.0
        if quantity > self.maxAmount{
            self.presentBottomAlertFullData(status: .error, message: "Monto excedido, solo se permiten transacciones de un monto máximo de $\(self.maxAmount)0 MXN", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.txtAmount.becomeFirstResponder()
            }
            return
        }else if (quantity < self.minAmount){
            self.presentBottomAlertFullData(status: .error, message: "Es necesario colocar un monto mayor a $\(self.minAmount)0", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.txtAmount.becomeFirstResponder()
            }
            return
        }else{
            let alert = UIAlertController(title: "Comisión",
                                          message: "Se cobrará una comisión de $\(comission).00 MXN por esta transacción.\n¿Deseas continuar?",
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { [weak self] _ in
                guard let self = self else { return }
                self.loadFondeo()
            })
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            if comission < "0" {
                presenter?.showAlert(alert)
            }else{
                self.loadFondeo()
            }
            return
        }
    }
    
    private func loadFondeo(){
        if startWithEmail == true{
            showFondeo()
        }else{
            GSVCLoader.show()
            self.presenter?.requestMailUpdate(body: UpdateMailBody.init(correoElectronico: GSSISessionInfo.sharedInstance.gsUser.email?.encryptAlnova()), Response: { Response in
                GSVCLoader.hide()
                if Response != nil{
                    self.showFondeo()
                }else{
                    self.showFondeo()
                }
            })
        }
    }
    
    @IBAction func next(sender: GSVCButton){
        showAlert()
    }
    
    
    func getEccomerceInformationSuccess(){
        if hasNav != true && close == false{
            startTime = Date()
            checkTime()
            txtAmount.addTarget(self, action: #selector(activityObserve), for: .editingChanged)
            let verification = GSVTDigitalSignViewController(delegate: self)
            verification.modalPresentationStyle = .fullScreen
            verification.bShouldWaitForNewToken = false
            present(verification, animated: true, completion: nil)
        }
        maxAmount = Double(GSSAFundSharedVariables.shared.ecommerceResponse?.montoMaximoTransferencia ?? "0.0") ?? 0.0
        maxAmountLabel.text = "Monto máximo $\(maxAmount)0"
        comission = GSSAFundSharedVariables.shared.ecommerceResponse?.comisionTransaccion ?? "0.00"
        
        dailyLimit = GSSAFundSharedVariables.shared.ecommerceSMTIResponse?.limiteDiario ?? false
        monthlyLimit = GSSAFundSharedVariables.shared.ecommerceSMTIResponse?.limiteMensual ?? false
        numDailyTransactions = GSSAFundSharedVariables.shared.ecommerceSMTIResponse?.numeroTransaccionesDiarias ?? 0
        numMonthlyTransactions = GSSAFundSharedVariables.shared.ecommerceSMTIResponse?.numeroTransaccionesMensuales ?? 0
        
        dailyTransactionsLimit = GSSAFundSharedVariables.shared.ecommerceResponse?.limiteTransaccionesDia ?? 0
        montlyTransactionsLimit = GSSAFundSharedVariables.shared.ecommerceResponse?.limiteTransaccionesMes ?? 0
        
        GSVCLoader.hide()
    }
    
    func getEccomerceInformationError(){
        showError()
    }
    
    private func showError(msg: String = "Ocurrió un error intentelo más tarde", subtitle: String? = nil, isDouble: Bool? = true) {
        activityObserved()
        
        GSVCLoader.hide()
        
        let view = getErrorMPViewController(subtitle: subtitle, message: msg, isDouble: isDouble)
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

extension GSSALinkDePagoViewController:GSSALinkDePagoCorreoViewControllerDelegate{
    func notifyCloseAction() {
        if hasNav == true{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func notifyEmail(email: String) {
        GSSISessionInfo.sharedInstance.gsUser.updateInfo(info: ["email": email])
        getEcommerceInformation()
    }
    
    
}
