//
//  BASACardConfigViewController.swift
//  TEST3
//
//  Created Andoni Suarez Martinez on 13/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSAFunctionalUtilities
import GSSASessionInfo
import FirebaseRemoteConfig
import AVKit

class BASACardConfigViewController: UIViewController, BASACardConfigViewProtocol, GSVCBottomAlertHandler{
    
    @IBOutlet weak var table: UITableView!
    
    struct userOptions {
        var title: String
        var subTitle: String?
        var image: UIImage?
        var tag: Int?
        var index: Int?
    }
    
    var configurations: Array<userOptions> = []
    var bottomAlert: GSVCBottomAlert?
    var presenter: BASACardConfigPresenterProtocol?
    var credit: Bool!
    var CLABE = ""
    var phone = ""
    var account = ""
    var debitCardNumber = ""
    var contractNumber = ""
    var cancelReload = false
    var cellsArray: Array<[UITableViewCell:CGFloat]> = []
    var defaultCaseTouchCount = 0
    var deviceShaked = false
    var trackingKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveValues()
        registerCells()
        setOptions()
        self.setBackButtonForOlderDevices(tint: .purple)
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        if credit == true{
            CLABE = ""
            setTableForDebitCard()
        }else{
            setTableForDebitCard()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if cancelReload == false{
            if myMoneyFrameworkSettings.shared.checkuserActivations == true{
                checkUserActivations()
            }else{
                if let cardStatusString = RemoteConfig.remoteConfig().remoteString(forKey: "iOS_MOB_SA_MMCARD"){
                    if cardStatusString == "true"{
                        checkUserActivations()
                    }
                }
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?){
        if motion == .motionShake{
            deviceShaked = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
    
    enum status{
        case unknown
        case request
        case activate
        case active
    }
    
    func checkUserActivations(){
        GSVCLoader.show()
        presenter?.requestCardInfo(DebitCardInfoResponse: { [self] DebitCardInfoResponse in
            if DebitCardInfoResponse != nil{
                let dataArray = DebitCardInfoResponse?.resultado?.numeroTarjeta?.components(separatedBy: "|")
                debitCardNumber = dataArray?[0].alnovaDecrypt() ?? ""
                contractNumber = dataArray?[1].alnovaDecrypt() ?? ""
                customToken.shared.contractNumber = dataArray?[1].alnovaDecrypt() ?? ""
                customToken.shared.debitCardNumber = debitCardNumber
                
                if let cardStatusString = RemoteConfig.remoteConfig().remoteString(forKey: "iOS_MOB_SA_MMPIN"){
                    if cardStatusString == "true" || myMoneyFrameworkSettings.shared.showPINinUserActivarions == true{
                        configureDebitCard(forStatus: .active )
                    }else{
                        GSVCLoader.hide()
                    }
                }
            }else{
                presenter?.requestCardStatus(CardSearchResponse: { [self] CardSearchResponse in
                    if CardSearchResponse != nil{
                        if CardSearchResponse?.resultado?.tarjeta?.estatus?.alnovaDecrypt().removeWhiteSpaces() != "ENTREGADA"{
                            trackingKey = CardSearchResponse?.resultado?.tarjeta?.numeroGuia ?? ""
                        }
                        configureDebitCard(forStatus: .activate)
                    }else{
                        configureDebitCard(forStatus: .request)
                    }
                })
            }
        })
        
    }
    
    func saveValues(){
        CLABE = GSSISessionInfo.sharedInstance.gsUser.account?.clabe?.tnuoccaFormat ?? ""
        phone = GSSISessionInfo.sharedInstance.gsUser.phone?.tryToAdCellphoneFormat ?? ""
        account =  GSSISessionInfo.sharedInstance.gsUser.account?.number?.formatToTnuocca14Digits().tnuoccaFormat ?? ""
    }
    
    func setOptions(){
        //Añade opciones genericas al menú de configuración
        let imgShare = UIImage.shareIcon()
        let chevronRight = UIImage.chevronRight()
        let docFill = UIImage.copyIcon()
        
        configurations.removeAll()
        
        if credit == false{
            configurations.append(userOptions(title: "CLABE Interbancaria", subTitle: CLABE, image: imgShare, tag: 4))
            configurations.append(userOptions(title: "Número de cuenta", subTitle: account, image: nil))
            configurations.append(userOptions(title: "Celular asociado", subTitle: phone, image: nil))
            if debitCardNumber != ""{
                configurations.append(userOptions(title: "Número de tarjeta", subTitle: debitCardNumber.tnuoccaFormat, image: nil, tag: nil, index: nil))
            }
            
            configurations.append(userOptions.init(title: "Estados de cuenta", subTitle: nil, image: chevronRight, tag: 1))
            configurations.append(userOptions.init(title: "Límites", subTitle: nil, image: chevronRight, tag: 2))
            configurations.append(userOptions.init(title: "Beneficiarios", subTitle: nil, image: chevronRight, tag: 3))
            //configurations.append(userOptions.init(title: "Activar tarjeta fisica", subTitle: nil, image: chevronRight, tag: 7))
        }else{
            configurations.append(userOptions(title: "Número de tarjeta", subTitle: CLABE, image: docFill, tag: 5))
            //  configurations.append(userOptions(title: "Estado de cuenta", subTitle: nil, image: chevronRight, tag: 1))
        }
        
    }
    
    func optionalAction() {()}
    
    func registerCells(){
        let bundle = Bundle.init(for: BASACardConfigViewController.self)
        table.register(UINib(nibName: "RequestCardCell", bundle: bundle), forCellReuseIdentifier: "RequestCardCell")
        table.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        table.register(UINib(nibName: "ConfigItemCell", bundle: bundle), forCellReuseIdentifier: "ConfigItemCell")
        table.register(UINib(nibName: "BASACardControl", bundle: bundle), forCellReuseIdentifier: "BASACardControl")
    }
    
    func removeAllExceptFirst(){
        if cellsArray.count > 0{
            let count = cellsArray.count
            for _ in 1..<count{
                cellsArray.removeLast()
            }
            
            var cellsToRemove: [IndexPath] = []
            
            for n in 1..<table.numberOfRows(inSection: 0){
                cellsToRemove.append([0,n])
            }
            
            table.deleteRows(at: cellsToRemove, with: .fade)
        }
    }
    
    func setTableForCreditCard(){
        removeAllExceptFirst()
        if myMoneyFrameworkSettings.shared.showCreditCardControlSettings == true{
            let cardControl = table.dequeueReusableCell(withIdentifier: "BASACardControl") as! BASACardControl
            cardControl.lblCheckNIP.text = "Activa tu tarjeta física"
            //cell.btnCheckNIP.addTarget(self, action: #selector(checkNIP(sender:)), for: .touchUpInside)
            cardControl.btnCheckNIP.addTarget(self, action: #selector(activateCreditCard), for: .touchUpInside)
            cardControl.turnOfSwitch.addTarget(self, action: #selector(turnOnCard(sender:)), for: .valueChanged)
            cardControl.reportCardView.isHidden = true
            cellsArray.append([cardControl:300.0])
        }
        
        let cell = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        cell.lblTitle.text = "Información"
        cellsArray.append([cell:50.0])
        
        for item in configurations{
            let cell = table.dequeueReusableCell(withIdentifier: "ConfigItemCell") as! ConfigItemCell
            let data = item
            cell.tag = data.tag ?? -1
            cell.configureCell(title: data.title, subtitle: data.subTitle, image: data.image)
            cellsArray.append([cell:75.0])
        }
        
    }
    
    func setTableForDebitCard(){
        removeAllExceptFirst()
        //Crea las celdas de las opciones genericas y añade nuevas al arreglo
        let cell = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        cell.lblTitle.text = "Información"
        cellsArray.append([cell:50.0])
        
        for item in configurations{
            let cell = table.dequeueReusableCell(withIdentifier: "ConfigItemCell") as! ConfigItemCell
            let data = item
            cell.tag = data.tag ?? -1
            cell.configureCell(title: data.title, subtitle: data.subTitle, image: data.image)
            cellsArray.append([cell:75.0])
        }
    }
    
    func configureDebitCard(forStatus: status){
        //Cambia el estado de la pantalla de configuración dependiendo del estatus de la tarjeta física
        DispatchQueue.main.async { [self] in
            if cellsArray.first?.first?.key is BASACardControl || cellsArray.first?.first?.key is RequestCardCell{
                cellsArray.removeFirst()
            }
            switch forStatus{
            case .request:
                let cell = table.dequeueReusableCell(withIdentifier: "RequestCardCell") as! RequestCardCell
                cell.lblTitle.text = "Solicita tu tarjeta"
                cell.buttonView.isUserInteractionEnabled = false
                cell.backgroundColor = UIColor.GSVCBase300()
                cell.tag = 6
                cellsArray.insert([cell:111.0], at: 0)
            case .activate:
                let cell = table.dequeueReusableCell(withIdentifier: "RequestCardCell") as! RequestCardCell
                cell.lblTitle.text = "Activa tu tarjeta"
                cell.buttonView.isUserInteractionEnabled = false
                cell.backgroundColor = UIColor.GSVCBase300()
                cell.tag = 7
                
                if trackingKey.alnovaDecrypt().removeWhiteSpaces() != ""{
                    cell.lblTracking.text = "Número de guía: \(trackingKey.alnovaDecrypt().removeWhiteSpaces()) DHL"
                }
                cellsArray.insert([cell:111.0], at: 0)
            case .active:
                //                let cell = table.dequeueReusableCell(withIdentifier: "BASACardControl") as! BASACardControl
                //                cell.nipCardView.isHidden = false
                //                cell.reportCardView.isHidden = false
                //                cell.btnCheckNIP.addTarget(self, action: #selector(checkNIP(sender:)), for: .touchUpInside)
                //                cell.turnOfSwitch.addTarget(self, action: #selector(turnOnCard(sender:)), for: .valueChanged)
                //                cellsArray.insert([cell:220.0], at: 0)
                let cell = table.dequeueReusableCell(withIdentifier: "RequestCardCell") as! RequestCardCell
                cell.lblTitle.text = "Ver NIP"
                cell.buttonView.isUserInteractionEnabled = false
                cell.backgroundColor = UIColor.GSVCBase300()
                cell.tag = 8
                cellsArray.insert([cell:111.0], at: 0)
                saveValues()
                setOptions()
                cancelReload = true
                setTableForDebitCard()
            case .unknown:
                ()
            }
            self.table.reloadData()
            GSVCLoader.hide()
        }
    }
    
    func handleEasterEgg(){
        let generator = UINotificationFeedbackGenerator()
        defaultCaseTouchCount += 1
        if defaultCaseTouchCount >= 5{
            generator.notificationOccurred(.warning)
            if UIPasteboard.general.string == "1"{
                defaultCaseTouchCount = 0
                generator.notificationOccurred(.error)
                let dictionary = Bundle.main.infoDictionary!
                let version = dictionary["CFBundleShortVersionString"] as! String
                let build = dictionary["CFBundleVersion"] as! String
                let mainInfo = "Main version \(version) build \(build)"
                presentBottomAlertFullData(status: .info, message: "BUNDLE VERSION \(Bundle.init(identifier: "mx.com.gruposalinas.GSSAMyMoney")?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "") \n \(mainInfo)", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            }else if UIPasteboard.general.string == Date().getString(withFormat: "HHmm"){
                generator.notificationOccurred(.error)
                let sharedinstance = GSSISessionInfo.sharedInstance.gsUser
                let string = "SICU: \(sharedinstance?.SICU ?? "SIN SICU")\nEMAIL: \(sharedinstance?.email ?? "SIN CORREO")\nACCOUNT: \(sharedinstance?.account?.number ?? "SIN NÙMERO DE CUENTA")\nNAME:\(getCompleteUserName())\nPHONE:\(sharedinstance?.phone ?? "SIN NÚMERO DE TELÉFONO")\nCARD:\(sharedinstance?.account?.card ?? "SIN NÚMERO DE TARJETA")"
                UIPasteboard.general.string = string
            }
        }
    }
    
    @objc func turnOnCard(sender: UISwitch){
        if sender.isOn{
            GSVCLoader.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                GSVCLoader.hide()
                self.tagCardSwitchClick(isOn: true)
                let alert = UIAlertController(title: "Apagaste tu tarjeta", message: "Las nuevas compras no serán procesadas. Puedes volver a encenderla cuando lo necesites. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }else{
            GSVCLoader.show()
            tagCardSwitchClick(isOn: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                GSVCLoader.hide()
                let alert = UIAlertController(title: "Encendiste tu tarjeta", message: "Las nuevas compras serán procesadas. Puedes volver a apagarla cuando lo necesites. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    @objc func checkNIP(sender: UIButton){
        let view = GSSACardNIPRouter.createModule(cvv: UserDefaults.standard.string(forKey: "DebitCardCVV") ?? "", contractNumber: contractNumber)
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @objc func activateCreditCard(){
        let view = GSSAActivateCreditCardRouter.createModule()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

extension BASACardConfigViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if credit == true{
            return configurations.count + 2
        }else{
            return cellsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellsArray[indexPath.row].first!.key
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return cellsArray[indexPath.row].first?.value ?? 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath)
        switch cell!.tag{
        case 1:
            var view = UIViewController()
            if credit == true{
                tagCardConfigStatementClick(origin: "credito")
                view = BASACardStatementsRouter.createModule(type: .credit)
            }else{
                tagCardConfigStatementClick(origin: "debito")
                view = BASACardStatementsRouter.createModule(type: .debit)
            }
            self.navigationController?.pushViewController(view, animated: true)
        case 2:
            tagCardConfigLimitsClick(origin: "debito")
            let view = BASACardLimitsRouter.createModule()
            self.navigationController?.pushViewController(view, animated: true)
        case 3:
            tagCardConfigBeneficiaryClick(origin: "debito")
            let view = BASABeneficiaryListRouter.createModule()
            self.navigationController?.pushViewController(view, animated: true)
        case 4:
            tagCardConfigShareInfo()
            let text = "Mi número de cuenta CLABE para enviarme dinero desde otro banco (SPEI) es:\n\(CLABE)\n\nMi número de cuenta para enviarme dinero dentro de baz es:\n\(account)\n\nMi número de celular asociado para envíos es:\n\(phone)"
            let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        case 5:
            self.presentBottomAlertFullData(status: .success, message: "Número de cuenta copiado", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            UIPasteboard.general.string = CLABE
        case 6:
            let view = GSSARequestDebitCardRouter.createModule()
            self.navigationController?.pushViewController(view, animated: true)
        case 7:
            tagCardConfigActivateCard()
            let view = GSSActivateDebitCardRouter.createModule()
            self.navigationController?.pushViewController(view, animated: true)
        case 8:
            if UserDefaults.standard.string(forKey: "DebitCardCVV") != nil{
                let view = GSSACardNIPRouter.createModule(cvv: UserDefaults.standard.string(forKey: "DebitCardCVV") ?? "", contractNumber: contractNumber)
                self.navigationController?.pushViewController(view, animated: true)
            }else{
                let view = GSSASetCVVRouter.createModule(cardNumber: "NIPFLOW")
                self.navigationController?.pushViewController(view, animated: true)
            }
        default:
            if deviceShaked == true{
                handleEasterEgg()
            }
        }
    }
}
