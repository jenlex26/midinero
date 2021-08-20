//
//  BASANewBeneficiaryViewController.swift
//  GSSAFront
//
//  Created Desarrollo on 14/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSASessionInfo
import GSSAServiceCoordinator

class BASANewBeneficiaryViewController: UIViewController, BASANewBeneficiaryViewProtocol, GSVCBottomAlertHandler{
    
    @IBOutlet weak var table: UITableView!
    
    var beneficiaryData: BeneficiaryItem?
    var tableFields: Array<beneficiaryField> = []
    var cellsArray: Array<[UITableViewCell:CGFloat]> = []
    var bottomAlert: GSVCBottomAlert?
    var presenter: BASANewBeneficiaryPresenterProtocol?
    var letUserEdit: Bool?
    var listResponseData: [BeneficiaryItem]!
    var canContinueProcess = false
    var updatedBeneficiaryPercents: [beneficiaryPercents] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackButtonForOlderDevices(tint: .purple)
        if beneficiaryData != nil{
            beneficiaryPublicData.shared.id = String(beneficiaryData?.id ?? -1)
            beneficiaryPublicData.shared.nombre = beneficiaryData?.nombre?.alnovaDecrypt().nameFormatter()
            beneficiaryPublicData.shared.fechaNacimiento = beneficiaryData?.fechaNacimiento?.alnovaDecrypt()
            beneficiaryPublicData.shared.numeroTelefono = beneficiaryData?.contacto?.numeroTelefono?.alnovaDecrypt()
            beneficiaryPublicData.shared.correoElectronico = beneficiaryData?.contacto?.correoElectronico?.alnovaDecrypt()
            beneficiaryPublicData.shared.fechaNacimiento = beneficiaryData?.fechaNacimiento?.alnovaDecrypt()
            beneficiaryPublicData.shared.porcentaje = beneficiaryData?.porcentaje?.alnovaDecrypt()
            beneficiaryPublicData.shared.apellidoPaterno = beneficiaryData?.apellidoPaterno?.alnovaDecrypt()
            beneficiaryPublicData.shared.apellidoMaterno = beneficiaryData?.apellidoMaterno?.alnovaDecrypt()
            beneficiaryPublicData.shared.idParentesco = beneficiaryData?.idParentesco
            useSessionInfoAddress()
        }
        
        if beneficiaryData?.nombre?.alnovaDecrypt().nameFormatter().count ?? 0 > 0{
            letUserEdit = false
        }else{
            letUserEdit = true
        }
        
        registerCells()
        setTextFields()
        setOptions()
        table.alwaysBounceVertical = false
        table.delegate = self
        table.dataSource = self
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        createTag(eventName: .pageView, section: "mi_dinero", flow: "dashboard", screenName: "datos_beneficiarios", origin: "debito")
    }
    
    func optionalAction() {
        print("Ok")
    }
    
    func registerCells(){
        let bundle = Bundle(for: BASANewBeneficiaryViewController.self)
        table.register(UINib(nibName: "BASASwitchItemCell", bundle: bundle), forCellReuseIdentifier: "BASASwitchItemCell")
        table.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        table.register(UINib(nibName: "BASATextFieldCell", bundle: bundle), forCellReuseIdentifier: "BASATextFieldCell")
        table.register(UINib(nibName: "BASAInfoCardCell", bundle: bundle), forCellReuseIdentifier: "BASAInfoCardCell")
        table.register(UINib(nibName: "BASAButtonCell", bundle: bundle), forCellReuseIdentifier: "BASAButtonCell")
    }
    
    func setOptions(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(sender:)), name: NSNotification.Name(rawValue: "TextFieldDidEnd"), object: nil)
        
        let headerCell = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        headerCell.lblTitle.styleType = 6
        headerCell.lblTitle.text = "Podrás agregar hasta cuatro beneficiarios."
        cellsArray.append([headerCell:70.0])
        
        let addressSwitchCell = table.dequeueReusableCell(withIdentifier: "BASASwitchItemCell") as! BASASwitchItemCell
        addressSwitchCell.lblSubTitle.isHidden = true
        addressSwitchCell.lblTitle.styleType = 6
        addressSwitchCell.backgroundColor = UIColor.GSVCBase300()
        addressSwitchCell.lblTitle.text = "Utilizar mi dirección"
        addressSwitchCell.tag = 1
        if beneficiaryData?.domicilio != nil{
            addressSwitchCell.swtch.isOn = false
        }else{
            addressSwitchCell.swtch.isOn = true
        }
        
        addressSwitchCell.swtch.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
        addressSwitchCell.separatorView.isHidden = true
        cellsArray.append([addressSwitchCell:56.0])
        
        for item in tableFields{
            let cell = table.dequeueReusableCell(withIdentifier: "BASATextFieldCell") as! BASATextFieldCell
            cell.configureCell(data: item)
            cellsArray.append([cell:117.0])
        }
        
        let percentCell = table.dequeueReusableCell(withIdentifier: "BASATextFieldCell") as! BASATextFieldCell
        let percent = String(Int(beneficiaryPublicData.shared.porcentaje ?? "0") ?? 0)
        if percent == "0"{
            percentCell.textField.text = ""
        }else{
            percentCell.textField.text = percent
        }
        percentCell.blankSpace.isHidden = false
        percentCell.textField.delegate = self
        percentCell.lblTitle.text = "Porcentaje otorgado"
        percentCell.textField.placeholder = "%"
        percentCell.textField.keyboardType = .numberPad
        
        let prefix = UILabel()
        prefix.font = percentCell.textField.font
        prefix.text = "%"
        prefix.sizeToFit()
        percentCell.textField.rightView = prefix
        percentCell.textField.rightViewMode = .whileEditing
        
        cellsArray.append([percentCell:117.0])
        
        let cell = table.dequeueReusableCell(withIdentifier: "BASAInfoCardCell") as! BASAInfoCardCell
        cell.lblText.text = "La suma total de tus beneficiarios debe dar un total del 100%"
        cellsArray.append([cell:110.0])
        
        let buttonCell = table.dequeueReusableCell(withIdentifier: "BASAButtonCell") as! BASAButtonCell
        buttonCell.btnNext.addTarget(self, action: #selector(validateFields), for: .touchUpInside)
        cellsArray.append([buttonCell:119.0])
    }
    
    func setTextFields(){
        tableFields.append(beneficiaryField(title: "Nombre", image: nil, placeHolder: nil, pickerData: nil, text: beneficiaryData?.nombre, isEnabled: letUserEdit))
        tableFields.append(beneficiaryField(title: "Apellido paterno", image: nil, placeHolder: nil, pickerData: nil, text: beneficiaryData?.apellidoPaterno, isEnabled: letUserEdit))
        tableFields.append(beneficiaryField(title: "Apellido materno", image: nil, placeHolder: nil, pickerData: nil, text: beneficiaryData?.apellidoMaterno, isEnabled: letUserEdit))
        
        tableFields.append(beneficiaryField(title: "Fecha de nacimiento", image: UIImage.calendarIcon(), placeHolder: "DD/MM/AAAA", pickerData: pickerTextField.init(pickerOptions: nil, datePicker: true, dateFormat: "dd/mm/yyyy"), text: beneficiaryData?.fechaNacimiento, isEnabled: letUserEdit))
            
        tableFields.append(beneficiaryField(title: "Parentesco", image: UIImage.chevronDown(), placeHolder: "Selecciona", pickerData: pickerTextField.init(pickerOptions: ["Hermano/a","Hijo-a","Padre/Madre","Abuelo/a","Conyuge","Nieto/a","Tio/a","Sobrino/a","Otro","Padre","Madre","Tutor","Empleado"], datePicker: false, dateFormat: nil), text: beneficiaryData?.idParentesco))
        
        tableFields.append(beneficiaryField(title: "Número telefónico", image: nil, placeHolder: nil, pickerData: nil, keyboardType: .numberPad, text: beneficiaryData?.contacto?.numeroTelefono))
        tableFields.append(beneficiaryField(title: "Correo electrónico", image: nil, placeHolder: nil, pickerData: nil, keyboardType: .emailAddress, text: beneficiaryData?.contacto?.correoElectronico))
    }
    
    @objc func switchChanged(sender: UISwitch){
        if sender.isOn == true{
            createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "datos_beneficiarios", type: "switch_on", element: "utilizar_direccion", origin: "debito")
            let alert = UIAlertController(title: "Baz", message: "¿Quieres que tu beneficiario utilice tu dirección?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                sender.isOn = true
                self.useSessionInfoAddress()
            }))
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {_ in
                sender.isOn = false
            }))
            self.present(alert, animated: true, completion: nil)
        }else{
            createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "datos_beneficiarios", type: "switch_off", element: "utilizar_direccion", origin: "debito")
            if beneficiaryData?.domicilio != nil {
                let view = GSSANewBeneficiaryAddressRouter.createModuleWithParams(data: beneficiaryData!.domicilio!)
                self.present(view, animated: true, completion: nil)
            }else{
                let view = GSSANewBeneficiaryAddressRouter.createModule()
                self.present(view, animated: true, completion: nil)
            }
        }
    }
    
    @objc func updateData(sender: Notification){
        if sender.object != nil{
            let object = sender.object as! [String:Int]
            if object.first!.value != -1{
                tableFields[object.first!.value].text = object.first!.key
            }
        }
    }
    
    @objc func validateFields(){
        self.view.endEditing(true)
        
        let addressBody = BeneficiaryAddress.init(calle: beneficiaryPublicData.shared.calle?.encryptAlnova(), numeroExterior: beneficiaryPublicData.shared.numeroExterior?.encryptAlnova(), numeroInterior: beneficiaryPublicData.shared.numeroInterior?.encryptAlnova(), colonia: beneficiaryPublicData.shared.colonia?.encryptAlnova(), municipio: beneficiaryPublicData.shared.municipio?.encryptAlnova(), estado: beneficiaryPublicData.shared.estado?.encryptAlnova(), codigoPostal: beneficiaryPublicData.shared.codigoPostal?.encryptAlnova())
        
        let contactBody = BeneficiaryContact.init(claveLada: "52".encryptAlnova(), numeroTelefono: beneficiaryPublicData.shared.numeroTelefono?.encryptAlnova(), numeroExtension: " ".encryptAlnova(), correoElectronico: beneficiaryPublicData.shared.correoElectronico?.encryptAlnova())
        
        
//        if beneficiaryData?.domicilio != nil{
//            addressBody = (beneficiaryData?.domicilio)!
//        }
        
        
        let thisBeneficiary = Beneficiario.init(id: beneficiaryPublicData.shared.id, nombre: beneficiaryPublicData.shared.nombre?.encryptAlnova(), apellidoPaterno: beneficiaryPublicData.shared.apellidoPaterno?.encryptAlnova(), apellidoMaterno: beneficiaryPublicData.shared.apellidoMaterno?.encryptAlnova(), fechaNacimiento: beneficiaryPublicData.shared.fechaNacimiento?.encryptAlnova(), idParentesco: beneficiaryPublicData.shared.idParentesco, porcentaje: beneficiaryPublicData.shared.porcentaje?.encryptAlnova(), domicilio: addressBody, contacto: contactBody)
        
        
        var hasEmptyTextField = false
        for txt in cellsArray{
            if txt.first?.key is BASATextFieldCell{
                let cell = txt.first?.key as! BASATextFieldCell
                if (cell.textField.text?.characterCount())! == 0{
                    hasEmptyTextField = true
                }
            }
        }
        
        if hasEmptyTextField == false{
            var beneficiariesArray = [thisBeneficiary]
            
            var notEmptyBeneficiaries: [beneficiaryPercents] = []
            
            for item in listResponseData{
                if item.id != Int(thisBeneficiary.id ?? "-1") && item.nombre?.alnovaDecrypt().haveData() == true{
                    let listBeneficiary = Beneficiario.init(id: String(item.id ?? -1), nombre: item.nombre, apellidoPaterno: item.apellidoPaterno, apellidoMaterno: item.apellidoMaterno, fechaNacimiento: item.fechaNacimiento, idParentesco: item.idParentesco, porcentaje: item.porcentaje, domicilio: item.domicilio, contacto: item.contacto)
                    
                    beneficiariesArray.append(listBeneficiary)
                }
            }
            
            
            for item in beneficiariesArray{
                if item.nombre?.alnovaDecrypt().removeWhiteSpaces().count ?? 0 > 0{
                    notEmptyBeneficiaries.append(beneficiaryPercents.init(name: item.nombre?.nameFormatter() ?? "" + " " + (item.apellidoMaterno ?? ""), percent: item.porcentaje ?? "0", id: item.id ?? "-1"))
                }
            }
            
            if canContinueProcess == true{
                for item in beneficiariesArray{
                    for insideItem in updatedBeneficiaryPercents{
                        if item.id == insideItem.id{
                            let newItem = Beneficiario.init(id: item.id, nombre: item.nombre, apellidoPaterno: item.apellidoPaterno, apellidoMaterno: item.apellidoMaterno, fechaNacimiento: item.fechaNacimiento, idParentesco: item.idParentesco, porcentaje: insideItem.percent, domicilio: item.domicilio, contacto: item.contacto)
                            beneficiariesArray.removeAll(where: {$0.id == item.id})
                            beneficiariesArray.append(newItem)
                        }
                    }
                }
                
                
                let body = NewBeneficiaryBody.init(numeroCuenta: GSSISessionInfo.sharedInstance.gsUser.mainAccount?.replacingOccurrences(of: " ", with: "").encryptAlnova(), beneficiarios: beneficiariesArray)
                
                var method = EKTHTTPRequestMethod.POST
                
                if beneficiaryData != nil{
                    method = .PUT
                }
                
                GSVCLoader.show()
                presenter?.requestSetNewBeneficiary(Body: body, method: method, DataCard: {DataCard in
                    GSVCLoader.hide()
                    if DataCard != nil{
                        let alert = UIAlertController(title: "Operación exitosa", message: "Datos guardados", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {_ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        self.presentBottomAlertFullData(status: .error, message: "No podemos guardar la información, en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
                        self.canContinueProcess = false
                    }
                })
            }else{
                evaluatePercents(Items: notEmptyBeneficiaries)
            }
        }else{
            self.presentBottomAlertFullData(status: .caution, message: "Faltan campos por completar", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
        }
    }
    
    func useSessionInfoAddress(){
        let sessionInfoAddress = GSSISessionInfo.sharedInstance.gsUser.address
        beneficiaryPublicData.shared.calle = sessionInfoAddress?.street
        beneficiaryPublicData.shared.numeroExterior = sessionInfoAddress?.externalNumber
        beneficiaryPublicData.shared.codigoPostal = sessionInfoAddress?.zipCode
        beneficiaryPublicData.shared.colonia = sessionInfoAddress?.neighborhood
        beneficiaryPublicData.shared.municipio = sessionInfoAddress?.city
        beneficiaryPublicData.shared.estado = sessionInfoAddress?.state
        beneficiaryPublicData.shared.pais = "México"
    }
    
    func evaluatePercents(Items: [beneficiaryPercents]){
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "datos_beneficiarios", type: "click", element: "continuar", origin: "debito")
        var total = 0
        canContinueProcess = false
        var outItems = Items
        if outItems.count > 1{
            
            let alert = UIAlertController(title: "Advertencia", message: "La suma de tus beneficiarios difiere del 100%, ajusta el porcentaje deseado para cada uno de ellos", preferredStyle: .alert)
            
            for item in Items{
                alert.addTextField { (textField) in
                    textField.placeholder = item.name.alnovaDecrypt()
                    textField.keyboardType = .numberPad
                    textField.accessibilityLabel = item.id
                    textField.delegate = self
                }
            }
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: {_ in
                self.canContinueProcess = false
            }))
            
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { [self]_ in
                for textfield in alert.textFields ?? []{
                    total = total + (Int(textfield.text ?? "0") ?? 0)
                }
                
                if total != 100{
                    let errorAlert = UIAlertController(title: "Baz", message: "La suma de beneficiarios debe ser igual a 100%", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: {[self]_ in
                        canContinueProcess = false
                    }))
                    self.present(errorAlert, animated: false, completion: nil)
                }else{
                    canContinueProcess = true
                    outItems.removeAll()
                    for textfield in alert.textFields ?? []{
                        outItems.append(beneficiaryPercents.init(name: ((textfield.placeholder?.encryptAlnova()) ?? ""), percent: (textfield.text?.encryptAlnova() ?? ""), id: (textfield.accessibilityLabel ?? "")))
                    }
                    updatedBeneficiaryPercents = outItems
                    validateFields()
                }
                
            }))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            canContinueProcess = true
            validateFields()
        }
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

extension BASANewBeneficiaryViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellsArray[indexPath.row].first?.key ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellsArray[indexPath.row].first?.value ?? 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if table.cellForRow(at: indexPath)?.tag == 1{
            if beneficiaryData?.domicilio != nil {
                let view = GSSANewBeneficiaryAddressRouter.createModuleWithParams(data: beneficiaryData!.domicilio!)
                self.present(view, animated: true, completion: nil)
            }else{
                let view = GSSANewBeneficiaryAddressRouter.createModule()
                self.present(view, animated: true, completion: nil)
            }
        }
    }
}

extension BASANewBeneficiaryViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.accessibilityLabel == nil{
            textField.placeholder = ""
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame.origin.y -= 100.0
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.accessibilityLabel == nil{
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame.origin.y = 0.0
            })
            beneficiaryPublicData.shared.porcentaje = textField.text
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 3
    }
}

extension NewBeneficiaryBody {
    func hasEmptyFields()-> Bool {
        let mirror = Mirror(reflecting: self)
        return mirror.children.contains(where: { $0.value as! String? != "" &&  $0.value as! String? != nil})
    }
}
