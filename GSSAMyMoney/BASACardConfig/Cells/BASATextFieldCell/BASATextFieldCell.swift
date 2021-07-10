//
//  BASATextFieldCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 14/06/21.
//

import UIKit
import GSSAVisualComponents
import GSSAFunctionalUtilities

class BASATextFieldCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: GSVCLabel!
    @IBOutlet weak var textField: GSVCTextField!
    @IBOutlet weak var blankSpace: UIView!
    
    var datePicker: GSVCPickerController!
    var picker: GSVCPickerController!
    
    var pickerData: Array<String> = []
    var dateFormatt = "dd/MM/yyyy"
    var index = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }
    
    func configureCell(data: beneficiaryField){
        textField.delegate = self
        
        lblTitle.text = data.title
        textField.text = data.text?.alnovaDecrypt()
        
        textField.placeholder = data.placeHolder
        if data.image != nil{
            textField.image = data.image!
        }
        
        if data.index != nil{
            index = data.index!
        }else{
            index = -1
        }
        
        if data.size == .small{
            blankSpace.isHidden = false
        }else{
            blankSpace.isHidden = true
        }
        
        textField.keyboardType = data.keyboardType ?? .default
        
        if data.pickerData != nil{
            switch data.pickerData!.datePicker {
            case true:
                datePicker = GSVCPickerController(type: .birthDate, textField: textField)
                datePicker.delegate = self
            default:
                pickerData = data.pickerData!.pickerOptions ?? []
                picker = GSVCPickerController(type: .data, textField: textField)
                picker.delegate = self
                picker.dataSource = self
            }
        }
    }
}

extension BASATextFieldCell: GSVCPickerControllerDelegate, GSVCPickerControllerDataSource, UITextFieldDelegate{
    func numberOfComponents(in textField: UITextField) -> Int {
        1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "TextFieldDidEnd"), object: [textField.text!: index], userInfo: nil))
        
        
        switch lblTitle?.text{
        
        case "Nombre":
            beneficiaryPublicData.shared.nombre = textField.text
        case "Apellido paterno":
            beneficiaryPublicData.shared.apellidoPaterno = textField.text
        case "Apellido materno":
            beneficiaryPublicData.shared.apellidoMaterno = textField.text
        case "Fecha de nacimiento":
            beneficiaryPublicData.shared.fechaNacimiento = textField.text
        case "Parentesco":
            beneficiaryPublicData.shared.idParentesco = textField.text?.kinShipID()
        case "Número telefónico":
            beneficiaryPublicData.shared.numeroTelefono = textField.text
        case "Correo electrónico":
            beneficiaryPublicData.shared.correoElectronico = textField.text
        case "Código postal":
            beneficiaryPublicData.shared.codigoPostal = textField.text
        case "Calle":
            beneficiaryPublicData.shared.calle = textField.text
        case "Número exterior":
            beneficiaryPublicData.shared.numeroExterior = textField.text
        case "Número interior":
            beneficiaryPublicData.shared.numeroInterior = textField.text
        case "Colonia":
            beneficiaryPublicData.shared.colonia = textField.text
        case .none:
            print("none Case")
        case .some(_):
            print("Unknowed case")
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "TextFieldDidStart"), object: [textField.text!: index], userInfo: nil))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: string)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        if textField.keyboardType != .numberPad && textField.keyboardType != .emailAddress{
            return count <= 18 && alphabet
        }else if textField.keyboardType == .numberPad{
            return count <= 10
        }else{
            return count <= 25
        }
    }
    
    func getElements(component: Int, textField: UITextField) -> [DataPicker]? {
        let dataPicker = pickerData.map { element -> DataPicker in
            return DataPicker(element, nil)
        }
        return dataPicker
    }
    
    func didSelect(date: Date, from textField: UITextField) {
        textField.text = GSFUDateConversor.getStringFrom(date, withFormat: "dd/MM/yyyy")
    }
    
    func didSelect(row: Int, key: String, value: Any?, from textField: UITextField) {
        textField.text = key
    }
}
