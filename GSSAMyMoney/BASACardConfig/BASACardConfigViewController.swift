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
import GSSASessionInfo

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
    var cellsArray: Array<[UITableViewCell:CGFloat]> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CLABE = GSSISessionInfo.sharedInstance.gsUser.account?.clabe?.tnuoccaFormat ?? ""
        phone = GSSISessionInfo.sharedInstance.gsUser.phone?.tryToAdCellphoneFormat ?? ""
        account = GSSISessionInfo.sharedInstance.gsUser.mainAccount?.formatToTnuocca14Digits().tnuoccaFormat ?? ""
        registerCells()
        setOptions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCustomCardStatusResponse(notification:)), name: NSNotification.Name(rawValue: "customCardStatusRequestResponse"), object: nil)
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        if credit == true{
            CLABE = ""
        }else{
            setTableForDebitCard()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        GSVCLoader.show()
        presenter?.requestCardStatus(CardSearchResponse: {})
    }
    
    enum status{
        case unknown
        case request
        case activate
        case active
    }
    
    func setOptions(){
        //Añade opciones genericas al menú de configuración
        let imgShare = UIImage.shareIcon()
        let chevronRight = UIImage.chevronRight()
        let docFill = UIImage.copyIcon()
        
        if credit == false{
            configurations.append(userOptions(title: "CLABE Interbancaria", subTitle: CLABE, image: imgShare, tag: 4))
            configurations.append(userOptions(title: "Número de cuenta", subTitle: account, image: nil))
            configurations.append(userOptions(title: "Celular asociado", subTitle: phone, image: nil))
            configurations.append(userOptions.init(title: "Estados de cuenta", subTitle: nil, image: chevronRight, tag: 1))
            configurations.append(userOptions.init(title: "Límites", subTitle: nil, image: chevronRight, tag: 2))
            configurations.append(userOptions.init(title: "Beneficiarios", subTitle: nil, image: chevronRight, tag: 3))
            //configurations.append(userOptions.init(title: "Activar tarjeta fisica", subTitle: nil, image: chevronRight, tag: 7))
        }else{
            configurations.append(userOptions(title: "Número de tarjeta física", subTitle: CLABE, image: docFill, tag: 5))
            configurations.append(userOptions(title: "Estado de cuenta", subTitle: nil, image: chevronRight, tag: 1))
        }
        
    }
    
    func optionalAction() {}
    
    func registerCells(){
        let bundle = Bundle.init(for: BASACardConfigViewController.self)
        table.register(UINib(nibName: "RequestCardCell", bundle: bundle), forCellReuseIdentifier: "RequestCardCell")
        table.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        table.register(UINib(nibName: "ConfigItemCell", bundle: bundle), forCellReuseIdentifier: "ConfigItemCell")
        table.register(UINib(nibName: "BASACardControl", bundle: bundle), forCellReuseIdentifier: "BASACardControl")
    }
    
    func setTableForDebitCard(){
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
                cellsArray.insert([cell:111.0], at: 0)
            case .active:
                let cell = table.dequeueReusableCell(withIdentifier: "BASACardControl") as! BASACardControl
                cell.nipCardView.isHidden = false
                cell.reportCardView.isHidden = false
                cell.btnCheckNIP.addTarget(self, action: #selector(checkNIP(sender:)), for: .touchUpInside)
                cell.turnOfSwitch.addTarget(self, action: #selector(turnOnCard(sender:)), for: .valueChanged)
                cellsArray.insert([cell:220.0], at: 0)
            case .unknown:
                print("DESCONOCIDO")
            }
            self.table.reloadData()
            GSVCLoader.hide()
        }
    }
    
    @objc func handleCustomCardStatusResponse(notification: Notification){
        //RECIBE una notificación con el status code del custom request y dependiendo de este determina las celdas que se mostrarán en ajustes
        let statusCode = notification.object as! Int
        switch statusCode{
        case 404:
            configureDebitCard(forStatus: .request)
        case 200:
            configureDebitCard(forStatus: .active)
        case 400:
            configureDebitCard(forStatus: .unknown)
        default:
            configureDebitCard(forStatus: .activate)
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
        let view = GSSACardNIPRouter.createModule()
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
        if credit == true{
            switch indexPath.row{
            case 0:
                let cell = table.dequeueReusableCell(withIdentifier: "BASACardControl") as! BASACardControl
                //cell.btnCheckNIP.addTarget(self, action: #selector(checkNIP(sender:)), for: .touchUpInside)
                cell.turnOfSwitch.addTarget(self, action: #selector(turnOnCard(sender:)), for: .valueChanged)
                cell.reportCardView.isHidden = true
                return cell
            case 1:
                let cell = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
                cell.lblTitle.text = "Información"
                return cell
            default:
                let cell = table.dequeueReusableCell(withIdentifier: "ConfigItemCell") as! ConfigItemCell
                let data = configurations[indexPath.row - 2]
                cell.tag = data.tag ?? -1
                cell.configureCell(title: data.title, subtitle: data.subTitle, image: data.image)
                return cell
            }
        }else{
            return cellsArray[indexPath.row].first!.key
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if credit == true{
            switch indexPath.row{
            case 0:
                return 165.0
            case 1:
                return 60.0
            default:
                return 75.0
            }
        }else{
            return cellsArray[indexPath.row].first?.value ?? 0.0
        }
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
        default:
            print("default case...")
        }
    }
}
