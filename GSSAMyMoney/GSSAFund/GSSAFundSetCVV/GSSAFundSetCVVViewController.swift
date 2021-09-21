//
//  GSSAFundSetCVVViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 03/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualTemplates
import GSSAVisualComponents
import baz_ios_sdk_link_pago

class GSSAFundSetCVVViewController: GSSAMasterViewController, UITextFieldDelegate {
    
    var presenter: GSSAFundSetCVVPresenterProtocol?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var cardInfoView: GSSACardInfoView!
    @IBOutlet weak var txtCVV: GSVCTextField!
    @IBOutlet weak var cvcInfoLabel: GSVCLabel!
    
    //MARK: - Properties
    var token: String = ""
    var originalViewFrame = CGFloat(0.0)
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        originalViewFrame = self.view.frame.origin.y
        setView()
        searchAccount()
        if #available(iOS 13.0, *){}else{
            txtCVV.image = UIImage(named: "openEye", in: Bundle.init(for: GSSAFundSetCVVViewController.self), compatibleWith: nil)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) ?? UIImage()
            txtCVV.imageTyped = UIImage(named: "closedEye", in: Bundle.init(for: GSSAFundSetCVVViewController.self), compatibleWith: nil)?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate) ?? UIImage()
            txtCVV.tintColor = UIColor.GSVCSecundary100
        }
        
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE{
            txtCVV.addTarget(self, action: #selector(startEditing), for: .editingDidBegin)
            txtCVV.addTarget(self, action: #selector(endEditing), for: .editingDidEnd)
        }
    }
    
    @objc func startEditing(){
        if self.view.frame.origin.y < 100.0 {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame.origin.y -= 100.0
            })
        }
    }
    
    @objc func endEditing(){
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame.origin.y += 100.0
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        setProgressLine(value: 0.50, animated: true)
    }
    
    //MARK: - @IBActions
    @IBAction func next(_ sender: Any) {
        txtCVV.setAppearance(.active)
        cvcInfoLabel.isHidden = false
        
        guard let cvv = txtCVV.text,
              cvv.count == 3 else {
            
            cvcInfoLabel.isHidden = true
            txtCVV.setAppearance(.error(message: "CVV invalido"))
            return
        }
        
        guard let responseCard = GSSAFundSharedVariables.shared.cardInformationResponse,
              let payer = responseCard.payer,
              let payerFirstName = payer.firstName,
              let payerLastName = payer.lastName,
              let cardType = responseCard.card?.type,
              let accountNumber = responseCard.card?.number,
              let expirationMonth = responseCard.card?.expirationMonth,
              let expirationYear = responseCard.card?.expirationYear else {
            
            showError()
            return
        }
        
        GSSAFundSharedVariables.shared.cvv = cvv
        GSSAFundSharedVariables.shared.cardInformation = LNKPG_CardInformationFacade(
            transactionCurrencyCode: GSSAFundSharedVariables.shared.currencyCode,
            payer: LNKPG_CardInformationFacade.__Payer(
                firstName: payerFirstName,
                lastName: payerLastName),
            card: LNKPG_CardInformationFacade.__Card(
                expirationMonth: expirationMonth,
                expirationYear: expirationYear,
                number: accountNumber,
                type: cardType))
        GSSAFundSharedVariables.shared.enrollmentRequest = LNKPG_EnrollmentRequestFacade(
            merchantID: GSSAFundSharedVariables.shared.ecommerceResponse?.comerciosCybs?.id ?? "",
            merchantReference: GSSAFundSharedVariables.shared.idTransaccionSuperApp ?? "",
            amount: String(GSSAFundSharedVariables.shared.transactionAmountPlusComission ?? 0.0)/* GSSAFundSharedVariables.shared.amount ?? ""*/,
            transactionCurrencyCode: GSSAFundSharedVariables.shared.currencyCode,
            card: LNKPG_EnrollmentRequestFacade.__card(
                number: accountNumber,
                expirationMonth: expirationMonth,
                expirationYear: expirationYear,
                type: GSSAFundSharedVariables.shared.getCardType(
                    cardNumer: accountNumber)))
        
        presenter?.goToNextFlow()
    }
}

//MARK: - View Methods
extension GSSAFundSetCVVViewController: GSSAFundSetCVVViewProtocol {
    func searchAccountSuccess(response: LNKPG_CardInformationResponseFacade) {
        GSVCLoader.hide()
        
        guard let firstName = response.payer?.firstName,
              let lastName = response.payer?.lastName,
              let type = response.card?.type,
              let expirationMonth = response.card?.expirationMonth,
              let expirationYear = response.card?.expirationYear,
              let accountNumber = response.card?.number else {
            
            showError()
            return 
        }
        
        GSSAFundSharedVariables.shared.cardInformation = LNKPG_CardInformationFacade(transactionCurrencyCode: GSSAFundSharedVariables.shared.currencyCode, payer: LNKPG_CardInformationFacade.__Payer(firstName: firstName, lastName: lastName), card: LNKPG_CardInformationFacade.__Card(expirationMonth: expirationMonth, expirationYear: expirationYear, number: accountNumber, type: type))
        GSSAFundSharedVariables.shared.cardInformationResponse = response
        cardInfoView.setupInfo(name: firstName + " " + lastName, bankName: type, accountNumber: accountNumber)
    }
    
    func searchAccountError() {
        GSVCLoader.hide()
        
        showError()
    }
}


//MARK: - Private functions

extension GSSAFundSetCVVViewController {
    private func setView() {
        self.title = "Recarga tu tarjeta"
        
        txtCVV.delegate = self
        txtCVV.contentFormat(.drowssap)
        txtCVV.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.txtCVV.isSecureTextEntry = !selected
        })
    }
    
    private func searchAccount(){
        GSVCLoader.show()
        presenter?.searchAccount(token: token)
    }
    
    private func showError(){
        let message = "Ocurrio un error intentelo más tarde"
        presenter?.goToError(message: message, isDouble: false)
    }
}
