//
//  GSSAFundAddCardViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 02/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSASessionInfo
import GSSAVisualComponents
import baz_ios_sdk_link_pago

class GSSAFundAddCardViewController: UIViewController {
    
    var presenter: GSSAFundAddCardPresenterProtocol?
    
    //MARK: - @IBOutlets
    @IBOutlet weak var nameField: GSVCTextField!
    @IBOutlet weak var lastNameField: GSVCTextField!
    @IBOutlet weak var emailField: GSVCTextField!
    @IBOutlet weak var phoneField: GSVCTextField!
    @IBOutlet weak var streetField: GSVCTextField!
    @IBOutlet weak var zipCodeField: GSVCTextField!
    @IBOutlet weak var cityField: GSVCTextField!
    @IBOutlet weak var countryField: GSVCTextField!
    @IBOutlet weak var stateField: GSVCTextField!
    @IBOutlet weak var apInfoLabel: GSVCLabel!
    @IBOutlet weak var nameInfoLabel: GSVCLabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    //MARK: - Properties
    var countries: [LNKPG_CountryFacade] = [LNKPG_CountryFacade]()
    var states: [LNKPG_StateFacade] = [LNKPG_StateFacade]()
    var requestCreateCard: LNKPG_TokenCardRequestFacade?
    var selectedCountry: LNKPG_CountryFacade?
    var countryPicker: GSVCPickerController!
    var statePicker: GSVCPickerController!
    var selectedState: LNKPG_StateFacade?
    var expirationMonth: String?
    var expirationYear: String?
    var number: String?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        createTag(eventName: .pageView, section: "mi_dinero", flow: "fondear_cuenta", screenName: "datos_personales", origin: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Methods
    @objc func keyboardWillShow(notification:NSNotification) {
        
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 80
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    
    func requestCountries() {
        presenter?.getCountries()
    }
    
    func requestStates() {
        GSVCLoader.show()
        
        if let selectedCountryCode = selectedCountry?.codigo {
            //presenter?.getStates(request: LNKPG_CountryStatesRequestFacade(countryCode: "MX"))
            presenter?.getStates(request: LNKPG_CountryStatesRequestFacade(countryCode: selectedCountryCode))
        }
    }
    
    func validateFields() -> Bool {
        var isValid = 0
        emailField.setAppearance(.active)
        nameField.setAppearance(.active)
        nameInfoLabel.isHidden = false
        lastNameField.setAppearance(.active)
        apInfoLabel.isHidden = false
        phoneField.setAppearance(.active)
        streetField.setAppearance(.active)
        zipCodeField.setAppearance(.active)
        cityField.setAppearance(.active)
        countryField.setAppearance(.active)
        stateField.setAppearance(.active)
        
        if nameField.text!.count == 0 || nameField.text!.count >= 50{
            nameField.setAppearance(.error(message: "Ingresa tu(s) nombre(s)"))
            nameInfoLabel.isHidden = true
            isValid += 1
        }
        
        if lastNameField.text!.count == 0 || lastNameField.text!.count >= 50{
            lastNameField.setAppearance(.error(message: "Ingresa tus apellidos"))
            apInfoLabel.isHidden = true
            isValid += 1
        }
        
        if phoneField.text!.count == 0 || phoneField.text!.count >= 11{
            phoneField.setAppearance(.error(message: "Ingresa tu número de celular"))
            isValid += 1
        }
        
        if streetField.text!.count == 0 || streetField.text!.count >= 50{
            streetField.setAppearance(.error(message: "Ingresa tu calle"))
            isValid += 1
        }
        
        if zipCodeField.text!.count == 0 || zipCodeField.text!.count >= 6{
            zipCodeField.setAppearance(.error(message: "Ingresa tu código postal"))
            isValid += 1
        }
        
        if cityField.text!.count == 0 || cityField.text!.count >= 50{
            cityField.setAppearance(.error(message: "Ingresa tu ciudad"))
            isValid += 1
        }
        
        if NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}").evaluate(with: emailField.text) == false{
            emailField.setAppearance(.error(message: "El correo electrónico no es valido"))
            emailField.becomeFirstResponder()
            isValid += 1
        }
        
        if emailField.text?.count == 0 || emailField.text == "" {
            emailField.setAppearance(.error(message: "Ingresa tu correo electrónico"))
            emailField.becomeFirstResponder()
            isValid += 1
        }
        
        if  self.selectedCountry == nil {
            countryField.setAppearance(.error(message: "Ingresa tu pais"))
            isValid += 1
        }
        
        if self.selectedState == nil {
            stateField.setAppearance(.error(message: "Ingresa tu estado"))
            isValid += 1
        }
        
        return isValid == 0 ? true : false
    }
    
    func showError() {
        GSVCLoader.hide()
        let message = "Ocurrio un error intentelo más tarde"
        self.navigationController?.pushViewController(self.getErrorMPViewController(message: message), animated: true)
    }
    
    //MARK: - @IBActions
    @IBAction func next(_ sender: Any) {
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "fondear_cuenta", screenName: "datos_personales", type: "click", element: "continuar", origin: "")
        if validateFields() {
            var userEmail = self.emailField.text
            
            if self.emailField.text?.haveData() == false{
                userEmail = GSSISessionInfo.sharedInstance.gsUser.email ?? ""
            }
            
            self.requestCreateCard = LNKPG_TokenCardRequestFacade(
                merchantID: GSSAFundSharedVariables.shared.ecommerceResponse?.comerciosCybs?.id ?? "",
                merchantReference: GSSAFundSharedVariables.shared.idTransaccionSuperApp ?? "",
                transactionCurrencyCode: "MXN",
                email: self.emailField.text!,
                payer: LNKPG_TokenCardRequestFacade.__Payer(
                    firstName: self.nameField.text!.removeDiacritics(),
                    lastName: self.lastNameField.text!.removeDiacritics(),
                    phoneNumber: self.phoneField.text!,
                    email: userEmail!,
                    address: LNKPG_TokenCardRequestFacade.__Payer.__Address(
                        street: self.streetField.text!.removeDiacritics(),
                        city: self.cityField.text!.removeDiacritics(),
                        state: self.selectedState!.name!.removeDiacritics(),
                        postalCode: self.zipCodeField.text!,
                        countryCode: self.selectedCountry!.codigo!)),
                card: LNKPG_TokenCardRequestFacade.__Card(
                    expirationMonth: expirationMonth ?? "00",
                    expirationYear: "20\(expirationYear ?? "")",
                    number: number?.replacingOccurrences(of: " ", with: "") ?? "00",
                    type: GSSAFundSharedVariables.shared.getCardType(cardNumer: number ?? "0")))
            
            GSSAFundSharedVariables.shared.createTokenRequest = self.requestCreateCard
            
            let view = GSSAConfirmCardSaveRouter.createModule(tokenCardRequest: requestCreateCard!)
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - Presenter Methods
extension GSSAFundAddCardViewController: GSSAFundAddCardViewProtocol {
    func getCountriesSuccess(response: LNKPG_CountriesResponseFacade) {
        self.countries.removeAll()
        
        guard let paises = response.paises else {
            GSVCLoader.hide()
            return
        }
        
        //self.countries = paises.map({$0})
        
        self.countries.append(contentsOf: paises)
        
        if self.countries.count > 0 {
            
            
            
            for country in self.countries {
                if country.codigo?.lowercased() == "mx" || country.nombre?.lowercased() == "mexico" {
                    self.selectedCountry = country
                    break
                }else {
                    if (AdquirienteServices.shared.enviroment == .release) {
                        self.selectedCountry = self.countries.first
                    }else{
                        self.selectedCountry = self.countries[146]//mexico
                    }
                }
            }
            
            /*if (AdquirienteServices.shared.enviroment == .release) {
                self.selectedCountry = self.countries.first
            }else{
                self.selectedCountry = self.countries[146]//mexico
            }*/
            
            self.countryField.text = self.selectedCountry?.nombre
            self.requestStates()
        } else {
            GSVCLoader.hide()
        }
    }
    
    func getCountriesError() {
        showError()
    }
    
    func getStatesSuccess(response: LNKPG_CountryStatesResponseFacade) {
        
        self.states.removeAll()
        
        guard let states = response.states else {
            GSVCLoader.hide()
            return
        }
        
        self.states.append(contentsOf: states)
        
        if self.states.count > 0 {
            self.stateField.isUserInteractionEnabled = true
            
            if let defaultStateName = GSSISessionInfo.sharedInstance.gsUser.address?.state {
                let findState = self.states.first { $0.name?.cleanString() == defaultStateName.cleanString() }
                
                if findState != nil {
                    self.selectedState = findState
                } else {
                    self.selectedState = self.states.first
                }
                
            } else {
                self.selectedState = self.states.first
            }
            
            self.stateField.text = self.selectedState?.name
        }
        
        GSVCLoader.hide()
    }
    
    func getStatesError() {
        showError()
    }
    
}

//MARK: - GSVCPickerControllerDelegate
extension GSSAFundAddCardViewController: GSVCPickerControllerDelegate {
    func didSelect(row: Int, key: String, value: Any?, from textField: UITextField) {
        switch textField.tag {
        case 7:
            selectedCountry = self.countries[row+2]
            countryField.text = key
            requestStates()
        case 8:
            selectedState = self.states[row]
            stateField.text = key
        default:
            break
        }
    }
}

//MARK: - GSVCPickerControllerDatasource
extension GSSAFundAddCardViewController: GSVCPickerControllerDataSource {
    func numberOfComponents(in textField: UITextField) -> Int {
        return 1
    }
    
    func getElements(component: Int, textField: UITextField) -> [DataPicker]? {

        switch textField.tag {
        case 7:
            return countries.map { DataPicker($0.nombre ?? "", nil) }
        case 8:
            return states.map { DataPicker($0.name ?? "", nil) }
        default:
            return nil
        }
    }
    
}

//MARK: - Private functions
extension GSSAFundAddCardViewController {
    private func setView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        stateField.isUserInteractionEnabled = false
        setBackButtonForOlderDevices(tint: .purple)
        GSVCLoader.show()
        
        nameField.allowActions(.allowAll)
        nameField.contentFormat(.uppercasedLettersAndNumbers)
        nameField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.nameField.text = ""
        })
        
        if #available(iOS 13.0, *){
            nameField.image = nameField.image.tint(with: .GSVCSecundary100)
            nameField.imageTyped = nameField.imageTyped.tint(with: .GSVCSecundary100)
            
            lastNameField.image = lastNameField.image.tint(with: .GSVCSecundary100)
            lastNameField.imageTyped = lastNameField.imageTyped.tint(with: .GSVCSecundary100)
            
            emailField.image = emailField.image.tint(with: .GSVCSecundary100)
            emailField.imageTyped = emailField.imageTyped.tint(with: .GSVCSecundary100)
            
            phoneField.image = phoneField.image.tint(with: .GSVCSecundary100)
            phoneField.imageTyped = phoneField.imageTyped.tint(with: .GSVCSecundary100)
            
            streetField.image = streetField.image.tint(with: .GSVCSecundary100)
            streetField.imageTyped = streetField.imageTyped.tint(with: .GSVCSecundary100)
            
            zipCodeField.image = zipCodeField.image.tint(with: .GSVCSecundary100)
            zipCodeField.imageTyped = zipCodeField.imageTyped.tint(with: .GSVCSecundary100)
            
            cityField.image = cityField.image.tint(with: .GSVCSecundary100)
            cityField.imageTyped = cityField.imageTyped.tint(with: .GSVCSecundary100)
        }
        
        lastNameField.allowActions(.allowAll)
        lastNameField.contentFormat(.uppercasedLettersAndNumbers)
        lastNameField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.lastNameField.text = ""
        })
        
        emailField.allowActions(.allowAll)
        emailField.contentFormat(.email)
        emailField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.emailField.text = ""
        })
        
        phoneField.allowActions(.allowAll)
        phoneField.contentFormat(.phone)
        phoneField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.phoneField.text = ""
        })
        
        streetField.allowActions(.allowAll)
        streetField.contentFormat(.address)
        streetField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.streetField.text = ""
        })
        
        zipCodeField.allowActions(.allowAll)
        zipCodeField.contentFormat(.numeric)
        zipCodeField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.zipCodeField.text = ""
        })
        
        cityField.allowActions(.allowAll)
        cityField.contentFormat(.address)
        cityField.rightButtonAction({ [weak self] selected in
            guard let self = self else { return }
            self.cityField.text = ""
        })
        
        
        statePicker = GSVCPickerController(type: .data, textField: stateField)
        statePicker.delegate = self
        statePicker.dataSource = self
        
        countryPicker = GSVCPickerController(type: .data, textField: self.countryField)
        countryPicker.delegate = self
        countryPicker.dataSource = self
        
        if let nombre = GSSISessionInfo.sharedInstance.gsUser.name {
            nameField.text = nombre
        }
        
        if let lastName = GSSISessionInfo.sharedInstance.gsUser.lastName,
           let secondLastName = GSSISessionInfo.sharedInstance.gsUser.secondLastName {
            lastNameField.text = lastName + " " + secondLastName
        }
        
        if let email = GSSISessionInfo.sharedInstance.gsUser.email {
            emailField.text = email.lowercased()
        }
        
        if let phone = GSSISessionInfo.sharedInstance.gsUser.phone {
            phoneField.text = phone
        }
        
        if let street = GSSISessionInfo.sharedInstance.gsUser.address?.street {
            streetField.text = street
        }
        
        if let zipCode = GSSISessionInfo.sharedInstance.gsUser.address?.zipCode {
            zipCodeField.text = zipCode
        }
        
        if let city = GSSISessionInfo.sharedInstance.gsUser.address?.city{
            cityField.text = city
        }
        
        requestCountries()
    }
}

