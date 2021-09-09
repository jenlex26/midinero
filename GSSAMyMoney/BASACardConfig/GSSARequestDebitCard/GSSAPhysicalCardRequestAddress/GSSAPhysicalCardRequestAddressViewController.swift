//
//  GSSAPhysicalCardRequestAddressViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 29/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualTemplates
import GSSAVisualComponents
import GSSASessionInfo

class GSSAPhysicalCardRequestAddressViewController: UIViewController, GSSAPhysicalCardRequestAddressViewProtocol, GSVCBottomAlertHandler, GSVCPickerControllerDelegate, GSVCPickerControllerDataSource{

    var bottomAlert: GSVCBottomAlert?
    var presenter: GSSAPhysicalCardRequestAddressPresenterProtocol?
    
    @IBOutlet weak var actualLocationView: UIView!
    @IBOutlet weak var btnTxtPostalCode  : UIButton!
    @IBOutlet weak var txtPostalCode     : GSVCTextField!
    @IBOutlet weak var txtColonia        : GSVCTextField!
    @IBOutlet weak var txtStreet         : GSVCTextField!
    @IBOutlet weak var txtExternalNumber : GSVCTextField!
    @IBOutlet weak var txtInternalNumber : GSVCTextField!
    @IBOutlet weak var txtCity           : GSVCLabel!
    @IBOutlet weak var txtState          : GSVCLabel!
    @IBOutlet weak var txtCountry        : GSVCLabel!
    @IBOutlet weak var btnPostalCode     : GSVCButton!
    
    var pickerData: [String:Int] = [:]
    var picker: GSVCPickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeFieldsVisibility(hidden: true)
        hideKeyboardWhenTappedAround()
        actualLocationView.backgroundColor = UIColor.GSVCBase300()
        txtPostalCode.delegate = self
        txtPostalCode.tag = 1
        txtStreet.delegate = self
        txtInternalNumber.delegate = self
        txtExternalNumber.delegate = self
        picker = GSVCPickerController(type: .data, textField: txtColonia)
        picker.delegate = self
        picker.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtPostalCode.becomeFirstResponder()
    }
    
    func optionalAction() {print("")}
    
    func changeFieldsVisibility(hidden: Bool){
        for item in self.view.subviews[1].subviews[0].subviews{
            if item.tag == 1{
                UIView.animate(withDuration: 0.5,
                               delay: 0.0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 1,
                               options: [],
                               animations: {
                                item.isHidden = hidden
                               })
            }
        }
    }
    
    func numberOfComponents(in textField: UITextField) -> Int {
        return 1
    }
    
    func getElements(component: Int, textField: UITextField) -> [DataPicker]? {
        let dataPicker = pickerData.keys.map { element -> DataPicker in
            return DataPicker(element, nil)
        }
        return dataPicker
    }
    
    @IBAction func changePostalCode(_ sender: Any){
        let alert = UIAlertController(title: "Baz", message: "¿Desea actualizar el código postal?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { [self]_ in
            changeFieldsVisibility(hidden: true)
            txtPostalCode.isUserInteractionEnabled = true
            btnPostalCode.isHidden = false
            btnTxtPostalCode.isUserInteractionEnabled = false
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func postalCodeButtonClick(_ sender: Any){
        if txtPostalCode.text?.count == 5{
            GSVCLoader.show()
            presenter?.requestLocationInfo(CP: txtPostalCode.text ?? "", LocationInfo: { [self] LocationInfo in
                GSVCLoader.hide()
                if LocationInfo != nil{
                    pickerData.removeAll()
                    changeFieldsVisibility(hidden: false)
                    btnPostalCode.isHidden = true
                    txtPostalCode.isUserInteractionEnabled = false
                    btnTxtPostalCode.isUserInteractionEnabled = true
                    txtCity.text = LocationInfo?.resultado?.municipio?.capitalized
                    txtState.text = LocationInfo?.resultado?.estado?.capitalized
                    txtCountry.text = LocationInfo?.resultado?.pais?.capitalized
                    for item in LocationInfo!.resultado!.colonias!{
                        pickerData.updateValue(item.id ?? -1, forKey: item.nombre ?? "")
                    }
                }else{
                    self.presentBottomAlertFullData(status: .error, message: "Verifique que el código postal sea válido", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
                }
            })
        }else{
            self.presentBottomAlertFullData(status: .error, message: "Ingrese un código postal válido", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
        }
    }
    
    @IBAction func useCurrentLocation(_ sender: Any){
        let savedAddress = GSSISessionInfo.sharedInstance.gsUser.address
        requestedAddress.shared.city = savedAddress?.city
        requestedAddress.shared.country = "México"
        requestedAddress.shared.externalNumber = savedAddress?.externalNumber
        requestedAddress.shared.postalCode = savedAddress?.zipCode
        requestedAddress.shared.state = savedAddress?.state
        requestedAddress.shared.street = savedAddress?.street
        requestedAddress.shared.suburb = savedAddress?.neighborhood
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func next(_ sender: Any){
        if txtCity.text?.haveData() == true && txtStreet.text?.haveData() == true && txtExternalNumber.text?.haveData() == true{
            requestedAddress.shared.street = txtStreet.text
            requestedAddress.shared.postalCode = txtPostalCode.text
            requestedAddress.shared.suburb = txtColonia.text
            requestedAddress.shared.externalNumber = txtExternalNumber.text
            requestedAddress.shared.internalNumber = txtInternalNumber.text
            requestedAddress.shared.city = txtCity.text
            requestedAddress.shared.state = txtState.text
            requestedAddress.shared.country = txtCountry.text
            self.navigationController?.popViewController(animated: true)
        }else{
            self.presentBottomAlertFullData(status: .error, message: "Faltan campos por completar", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
        }
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

extension GSSAPhysicalCardRequestAddressViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyzñÑ0123456789 "
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        
        switch textField.tag{
        case 1:
            return updatedText.count <= 5 && (string == filtered)
        default:
            return updatedText.count <= 40 && (string == filtered)
        }
    }
}

public struct requestedAddress{
    static var shared = requestedAddress()
    var amount              : String? 
    var postalCode          : String?
    var suburb              : String? //Colonia
    var street              : String?
    var externalNumber      : String?
    var internalNumber      : String?
    var city                : String? //Municipio-Alcaldia
    var state               : String?
    var country             : String?
    private init() { }
}
