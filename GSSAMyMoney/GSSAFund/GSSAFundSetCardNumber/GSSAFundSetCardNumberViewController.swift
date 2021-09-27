//
//  GSSAFundSetCardNumberViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 02/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import baz_ios_sdk_link_pago

class GSSAFundSetCardNumberViewController: UIViewController, GSSAFundSetCardNumberViewProtocol {
    
	var presenter: GSSAFundSetCardNumberPresenterProtocol?
    
    //MARK: - @IBOUtlets
    @IBOutlet weak var cardNumberTextField: GSVCTextField!
    @IBOutlet weak var expirationTextField: GSVCTextField!
    @IBOutlet weak var cvvTextField: GSVCTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Life cycle
	override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        createTag(eventName: .pageView, section: "mi_dinero", flow: "fondear_cuenta", screenName: "nueva_tarjeta", origin: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: - Methods
    private func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setBackButtonForOlderDevices(tint: .purple)
        cardNumberTextField.delegate = self
        cardNumberTextField.allowActions(.allowAll)
        cardNumberTextField.contentFormat(.numeric)
        
        expirationTextField.delegate = self
        
        cvvTextField.delegate = self
        cvvTextField.contentFormat(.drowssap)
        cvvTextField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.cvvTextField.isSecureTextEntry = !selected
        })
        if #available(iOS 13.0, *){}else{
            cvvTextField.image = UIImage(named: "openEye", in: Bundle.init(for: GSSAFundSetCVVViewController.self), compatibleWith: nil)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) ?? UIImage()
            cvvTextField.imageTyped = UIImage(named: "closedEye", in: Bundle.init(for: GSSAFundSetCVVViewController.self), compatibleWith: nil)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) ?? UIImage()
        }
        cvvTextField.image = cvvTextField.image.tint(with: UIColor.GSVCSecundary100)
        cvvTextField.imageTyped = cvvTextField.imageTyped.tint(with: .GSVCSecundary100)
    }
     
    //MARK: - IBActions
    @IBAction func next(_ sender: Any) {
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "fondear_cuenta", screenName: "nueva_tarjeta", type: "click", element: "continuar", origin: "")
        presenter?.checkTextFields(cardNumber: cardNumberTextField.text,
                                   expiration: expirationTextField.text,
                                   cvv: cvvTextField.text)
    }
    
    @IBAction func close(_ sender: Any) {
        self.presenter?.goBack()
    }

}

//MARK: - Presenter Methods
extension GSSAFundSetCardNumberViewController {
    
    func areTextFieldsCorrect(cardNumber: String, expiration: String, cvv: String) {
        let card = cardNumber.replacingOccurrences(of: " ", with: "")
        let expirationYear = String(expiration.split(separator: "/")[1])
        let expirationMonth = String(expiration.split(separator: "/")[0])
        
        let merchantID = GSSAFundSharedVariables.shared.ecommerceResponse?.comerciosCybs?.id ?? ""
        let merchantReference = GSSAFundSharedVariables.shared.idTransaccionSuperApp ?? ""
        let amount =  String(GSSAFundSharedVariables.shared.transactionAmountPlusComission ?? 0.0) /*GSSAFundSharedVariables.shared.amount ?? ""*/
        let currencyCode = GSSAFundSharedVariables.shared.currencyCode
        
        let type = GSSAFundSharedVariables.shared.getCardType(cardNumer: cardNumber)
        let expirationYear2 = "20\(expirationYear)"
        
        let enrollmentRequestCard = LNKPG_EnrollmentRequestFacade.__card(number: card, expirationMonth: expirationMonth, expirationYear: expirationYear2, type: type)
        let enrollmentRequest = LNKPG_EnrollmentRequestFacade(merchantID: merchantID, merchantReference: merchantReference, amount: amount, transactionCurrencyCode: currencyCode, card: enrollmentRequestCard)
        
        GSSAFundSharedVariables.shared.enrollmentRequest = enrollmentRequest
        GSSAFundSharedVariables.shared.cvv = cvv
        
        let view = GSSAFundAddCardRouter.createModule(expirationMonth: expirationMonth,
                                                      expirationYear: expirationYear,
                                                      number: cardNumber)
        self.presenter?.goToAddAddress(view)
    }
    
    func cardNumberIsEmpty(_ isEmpty: Bool) {
        if isEmpty { cardNumberTextField.setAppearance(.error(message: "Ingresa el número de tarjeta")) }
        else { cardNumberTextField.setAppearance(.active) }
    }
    
    func expirationIsEmpty(_ isEmpty: Bool) {
        if isEmpty { expirationTextField.setAppearance(.error(message: "Ingresa vencimiento")) }
        else { expirationTextField.setAppearance(.active) }
    }
    
    func cvvIsEmpty(_ isEmpty: Bool) {
        if isEmpty { cvvTextField.setAppearance(.error(message: "Ingresa el CVV")) }
        else { cvvTextField.setAppearance(.active) }
    }

}

//MARK: - UITextFieldDelegate
extension GSSAFundSetCardNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let r = Range(range, in: oldText) else { return true }
        let updatedText = oldText.replacingCharacters(in: r, with: string)
        
        if textField.tag == 1 {
            if updatedText.count >= 20 { return false }
            textField.text = updatedText.numbergrouping(every: 4, with: " ")
            return false
        }
        
        if textField.tag == 2 {
            if string == "" {
                if updatedText.count == 2 {
                    textField.text = "\(updatedText.prefix(1))"
                    return false
                }
            } else if updatedText.count == 1 {
                if updatedText > "1" { return false }
            } else if updatedText.count == 2 {
                if updatedText <= "12" { textField.text = "\(updatedText)/" }
                return false
            }
            
            return true
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 2 || textField.tag == 3 {
            scrollView.setContentOffset(CGPoint(x: 0.0, y: 100.0), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 2 || textField.tag == 3 {
            scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
        }
    }
}
