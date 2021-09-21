//
//  GSSAConfirmCardSaveViewController.swift
//  GSSAMyMoney
//
//  Created Usuario Phinder 2021 on 02/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import baz_ios_sdk_link_pago

class GSSAConfirmCardSaveViewController: GSSAMasterViewController, GSSAConfirmCardSaveViewProtocol, GSVCBottomAlertHandler {
    var bottomAlert: GSVCBottomAlert?
    var presenter: GSSAConfirmCardSavePresenterProtocol?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var aliasTextField: GSVCTextField!
    @IBOutlet weak var cardInfoView: GSSACardInfoView!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var editBtn: GSVCButton!
    @IBOutlet weak var saveCardSwitch: UISwitch!
    
    //MARK: - Properties
    var tokenCardRequest: LNKPG_TokenCardRequestFacade?
    private var canSave: Bool = false
    //MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    //MARK: - @IBActions
    @IBAction func next(_ sender: Any) {
        guard let tokenCardRequest = tokenCardRequest,
              let firstName = tokenCardRequest.payer?.firstName,
              let lastName = tokenCardRequest.payer?.lastName,          
              let accountNumber = tokenCardRequest.card?.number,
              let expirationMonth = tokenCardRequest.card?.expirationMonth,
              let expirationYear = tokenCardRequest.card?.expirationYear,
              let type = tokenCardRequest.card?.type else { return }
        
        GSSAFundSharedVariables.shared.cardInformation = LNKPG_CardInformationFacade(transactionCurrencyCode: GSSAFundSharedVariables.shared.currencyCode, payer: LNKPG_CardInformationFacade.__Payer(firstName: firstName, lastName: lastName), card: LNKPG_CardInformationFacade.__Card(expirationMonth: expirationMonth, expirationYear: expirationYear, number: accountNumber, type: type))
        
        
        
            GSVCLoader.show()
            presenter?.requestSaveCard(tokenCardRequest: tokenCardRequest)
    }
    
    @IBAction func editAction(_ sender: Any) {
        presenter?.returnTo(vc: GSSAFundSetCardNumberViewController.self, animated: false)
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onChangeSaveCard(_ sender: UISwitch) {
        if !canSave {
            sender.setOn(false, animated: false)
            showBottomAlert(msg: "Ya no puede guardar más tarjetas porque supero el límite")
        }
        
    }
}

//MARK: - UITextFieldDelegate
extension GSSAConfirmCardSaveViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

//MARK: - Presenter Methods
extension GSSAConfirmCardSaveViewController {
    func onSuccess(_ response: LNKPG_TokenCardResponseFacade) {
        GSVCLoader.hide()
        
        //presenter?.goToError(message: "Alta procesada, su tarjeta estará activa en 24 horas",isDouble: false,  isWarning: true)
        presenter?.goToNextFlow()
    }
    
    func onError() {
        showError()
    }
}

//MARK: - Private functions
extension GSSAConfirmCardSaveViewController {
    private func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setBackButtonForOlderDevices(tint: .purple)
        aliasTextField.allowActions(.allowAll)
        aliasTextField.delegate = self
        aliasTextField.contentFormat(.uppercasedLettersAndNumbers)
        aliasTextField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.aliasTextField.text = ""
        })
        
        editBtn.setTitleColor(.GSVCPrincipal100, for: .normal)
        saveView.backgroundColor = .GSVCBase200
        
        
        print(GSSAFundSharedVariables.shared.ecommerceSMMIResponse)
        
        canSave = true
        
        setupInfo()
    }
    
    private func setupInfo(){
        guard let tokenCardRequest = tokenCardRequest,
              let firstName = tokenCardRequest.payer?.firstName,
              let lastName = tokenCardRequest.payer?.lastName,
              let card = tokenCardRequest.card?.number,
              let type = tokenCardRequest.card?.type else {
            showError()
            return
        }
        
        let name = "\(firstName) \(lastName)"
        cardInfoView.setupInfo(name: name, bankName: type, accountNumber: card)
    }
    
    private func showError() {
        GSVCLoader.hide()
        let message = "Ocurrio un error intentelo más tarde"
        
        presenter?.goToError(message: message, isDouble: false, isWarning: false)
    }
    
    internal func showErrorTokenNoActivo() {
        GSVCLoader.hide()
        let message = "Alta procesada, su tarjeta estará activa en 24 horas"
        presenter?.goToError(message: message, isDouble: false, isWarning: false)
    }
    
    private func showBottomAlert(msg: String) {
        self.presentBottomAlertFullData(status: .caution, message: msg, attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
    }
}
