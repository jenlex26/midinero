//
//  GSSANewBeneficiaryAddressViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 30/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents

class GSSANewBeneficiaryAddressViewController: UIViewController, GSSANewBeneficiaryAddressViewProtocol, GSVCBottomAlertHandler {
    var bottomAlert: GSVCBottomAlert?
    
    func optionalAction() {
        print("OK")
    }
    
    @IBOutlet weak var table: UITableView!
    
    var presenter: GSSANewBeneficiaryAddressPresenterProtocol?
    var cellsArray: Array<[UITableViewCell:CGFloat]> = []
    var beneficiaryData: BeneficiaryAddress?
    var clearData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        registerCells()
        setOptions()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func registerCells(){
        let bundle = Bundle(for: GSSANewBeneficiaryAddressViewController.self)
        table.register(UINib(nibName: "BASASwitchItemCell", bundle: bundle), forCellReuseIdentifier: "BASASwitchItemCell")
        table.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        table.register(UINib(nibName: "BASATextFieldCell", bundle: bundle), forCellReuseIdentifier: "BASATextFieldCell")
        table.register(UINib(nibName: "BASAInfoCardCell", bundle: bundle), forCellReuseIdentifier: "BASAInfoCardCell")
        table.register(UINib(nibName: "BASAButtonCell", bundle: bundle), forCellReuseIdentifier: "BASAButtonCell")
    }
    
    func setOptions(){
        cellsArray.removeAll()
        var singletoneData =  beneficiaryPublicData.shared
        
        if beneficiaryData != nil{
            singletoneData.calle = beneficiaryData?.calle?.alnovaDecrypt().nameFormatter()
            singletoneData.numeroExterior = beneficiaryData?.numeroExterior?.alnovaDecrypt().removeWhiteSpaces()
            singletoneData.numeroInterior = beneficiaryData?.numeroInterior?.alnovaDecrypt().removeWhiteSpaces()
            singletoneData.codigoPostal =  beneficiaryData?.codigoPostal?.alnovaDecrypt().removeWhiteSpaces()
        }else{
            if clearData == true{
                singletoneData.calle = ""
                singletoneData.numeroExterior = ""
                singletoneData.numeroInterior = ""
                singletoneData.codigoPostal = ""
            }
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(sender:)), name: NSNotification.Name(rawValue: "TextFieldDidEnd"), object: nil)
        
        let street = table.dequeueReusableCell(withIdentifier: "BASATextFieldCell") as! BASATextFieldCell
        street.lblTitle.text = "Calle"
        street.textField.text = singletoneData.calle
        street.textField.placeholder = nil
        street.textField.returnKeyType = .next
        street.textField.tag = 0
        street.textField.contentType(.streetAddressLine1)
        street.textField.delegate = self
        cellsArray.append([street:117.0])
        
        let streetNumber = table.dequeueReusableCell(withIdentifier: "BASATextFieldCell") as! BASATextFieldCell
        streetNumber.lblTitle.text = "Número exterior"
        streetNumber.textField.text = singletoneData.numeroExterior
        streetNumber.textField.placeholder = nil
        streetNumber.textField.returnKeyType = .next
        streetNumber.textField.tag = 1
        streetNumber.textField.keyboardType = .numberPad
        streetNumber.textField.delegate = self
        cellsArray.append([streetNumber:117.0])
        
        let internalNumber = table.dequeueReusableCell(withIdentifier: "BASATextFieldCell") as! BASATextFieldCell
        internalNumber.lblTitle.text = "Número interior"
        internalNumber.textField.placeholder = "Opcional"
        internalNumber.textField.text = singletoneData.numeroInterior
        internalNumber.textField.placeholder = nil
        internalNumber.textField.returnKeyType = .next
        internalNumber.textField.keyboardType = .numberPad
        internalNumber.textField.tag = 2
        internalNumber.textField.contentType(.streetAddressLine2)
        internalNumber.textField.delegate = self
        cellsArray.append([internalNumber:117.0])
        
        let postalCode = table.dequeueReusableCell(withIdentifier: "BASATextFieldCell") as! BASATextFieldCell
        postalCode.lblTitle.text = "Código postal"
        postalCode.textField.text = singletoneData.codigoPostal
        postalCode.textField.placeholder = nil
        postalCode.textField.keyboardType = .numberPad
        postalCode.textField.delegate = self
        postalCode.textField.returnKeyType = .done
        postalCode.textField.contentType(.postalCode)
        postalCode.textField.tag = 3
        cellsArray.append([postalCode:117.0])
        
        let button = table.dequeueReusableCell(withIdentifier: "BASAButtonCell") as! BASAButtonCell
        button.btnNext.setTitle("Continuar", for: .normal)
        button.btnNext.addTarget(self, action: #selector(continueButtonClick(sender:)), for: .touchUpInside)
        button.btnNext.tag = 2
        cellsArray.append([button:117.0])
    }
    
    @objc func keyboardWillAppear() {
        bottomAlert?.animateDismissal()
        bottomAlert = nil
    }
    
    @objc func continueButtonClick(sender: UIButton){
        self.view.endEditing(true)
        if sender.tag == -1{
            self.presentBottomAlertFullData(status: .error, message: "Ingrese un código postal valido", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
        }else{
            var hasEmptyTextField = false
            for item in cellsArray{
                if item.first?.key is BASATextFieldCell{
                    let cell = item.first?.key as! BASATextFieldCell
                    if (cell.textField.text?.characterCount())! == 0{
                        hasEmptyTextField = true
                    }
                    switch cell.lblTitle.text{
                    case "Calle":
                        beneficiaryPublicData.shared.calle = cell.textField.text
                    case "Número exterior":
                        beneficiaryPublicData.shared.numeroExterior = cell.textField.text
                    case "Número interior":
                        beneficiaryPublicData.shared.numeroInterior = cell.textField.text
                    case "Código postal":
                        beneficiaryPublicData.shared.codigoPostal = cell.textField.text
                    case .none:
                        print("none case")
                    case .some(_):
                        print("unknowed case")
                    }
                }
            }
            if hasEmptyTextField == false{
                if sender.tag == 1{
                    let alert = UIAlertController(title: "Baz", message: "Al continuar confirmas que todos los datos son correctos.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    GSVCLoader.show(type: .native)
                    presenter?.requestLocationInfo(CP: beneficiaryPublicData.shared.codigoPostal ?? "", LocationInfo: { [self] LocationInfo in
                        GSVCLoader.hide()
                        if LocationInfo != nil {
                            cellsArray.removeLast()
                            
                            for item in cellsArray{
                                if item.first?.key is BASATextFieldCell{
                                    let cell = item.first?.key as! BASATextFieldCell
                                    if cell.textField.tag == 3{
                                        cell.tag = 3
                                        cell.textField.isEnabled = false
                                    }
                                }
                            }
                            
                            
                            var colonias = [""]
                            
                            let serviceColonias = LocationInfo!.resultado!.colonias ?? []
                            
                            for item in serviceColonias{
                                colonias.append(item.nombre ?? "")
                            }
                            
                            if #available(iOS 13.0, *) {
                                let postalCodePickerData = beneficiaryField(title: "Colonia", image: UIImage(systemName: "chevron.down"), placeHolder: "Selecciona", pickerData: pickerTextField.init(pickerOptions: colonias, datePicker: false, dateFormat: nil))
                                
                                let cell = table.dequeueReusableCell(withIdentifier: "BASATextFieldCell") as! BASATextFieldCell
                                cell.configureCell(data: postalCodePickerData)
                                cellsArray.append([cell:117.0])
                            }
                            
                            let section = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
                            section.lblTitle.text = "Alcaldía o municipio"
                            section.lblSubTitle.isHidden = false
                            section.lblSubTitle.text = LocationInfo?.resultado?.municipio
                            beneficiaryPublicData.shared.municipio = LocationInfo?.resultado?.municipio
                            cellsArray.append([section:80.0])
                            
                            let stateSection = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
                            stateSection.lblTitle.text = "Estado o ciudad"
                            stateSection.lblSubTitle.isHidden = false
                            stateSection.lblSubTitle.text = LocationInfo?.resultado?.estado
                            beneficiaryPublicData.shared.estado = LocationInfo?.resultado?.estado
                            cellsArray.append([stateSection:80.0])
                            
                            let countrySection = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
                            countrySection.lblTitle.text = "País"
                            countrySection.lblSubTitle.isHidden = false
                            countrySection.lblSubTitle.text = LocationInfo?.resultado?.pais
                            beneficiaryPublicData.shared.pais = LocationInfo?.resultado?.pais
                            cellsArray.append([countrySection:80.0])
                            
                            let button = table.dequeueReusableCell(withIdentifier: "BASAButtonCell") as! BASAButtonCell
                            button.btnNext.setTitle("Continuar", for: .normal)
                            button.btnNext.tag = 1
                            button.btnNext.addTarget(self, action: #selector(continueButtonClick(sender:)), for: .touchUpInside)
                            cellsArray.append([button:117.0])
                            
                            self.table.reloadData()
                            
                        }else{
                            self.presentBottomAlertFullData(status: .error, message: "Verifique que el código postal sea válido", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
                        }
                        
                    })
                    
                }
            }else{
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.error)
                self.presentBottomAlertFullData(status: .error, message: "Faltan campos por completar", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        }
    }
    
    @objc func updateData(sender: Notification){
        print(sender.object as Any)
    }
    
    @IBAction func close(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension GSSANewBeneficiaryAddressViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellsArray[indexPath.row].first!.key
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellsArray[indexPath.row].first!.value
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath)
        if cell?.tag == 3{
            let alert = UIAlertController(title: "Baz", message: "¿Desea cambiar el código postal?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                self.clearData = false
                self.setOptions()
                self.table.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension GSSANewBeneficiaryAddressViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 3{
            table.setContentOffset(CGPoint(x: 0.0, y: 100.0), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 3{
            table.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        switch textField.tag{
        case 3:
            return updatedText.count <= 5
        case 0:
            return updatedText.count <= 25
        case 1:
            return updatedText.count <= 5
        case 2:
            return updatedText.count <= 5
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField.tag {
        case 0:
            textField.resignFirstResponder()
            table.viewWithTag(1)?.becomeFirstResponder()
        case 1:
            textField.resignFirstResponder()
            table.viewWithTag(2)?.becomeFirstResponder()
        case 2:
            textField.resignFirstResponder()
            table.viewWithTag(3)?.becomeFirstResponder()
        case 3:
            self.view.endEditing(true)
        default:
            debugPrint("")
        }
        return true
    }
}
