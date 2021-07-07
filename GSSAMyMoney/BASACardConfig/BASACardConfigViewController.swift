//
//  BASACardConfigViewController.swift
//  TEST3
//
//  Created Desarrollo on 13/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSASessionInfo

class BASACardConfigViewController: UIViewController, BASACardConfigViewProtocol, GSVCBottomAlertHandler, GSVTDigitalSignDelegate {
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) {
        print("forgott")
    }
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        let view = BASABeneficiaryListRouter.createModule()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    var bottomAlert: GSVCBottomAlert?
    
    func optionalAction() {
        print("OK")
    }
    
    
    var presenter: BASACardConfigPresenterProtocol?
    var credit: Bool!
    
    @IBOutlet weak var table: UITableView!
    
    struct userOptions {
        var title: String
        var subTitle: String?
        var image: UIImage?
        var tag: Int?
        var index: Int?
    }
    
    var configurations: Array<userOptions> = []
    
    var CLABE = UserDefaults.standard.value(forKey: "DebitCardCLABE") as? String
    var phone = ""
    var account = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if credit == true{
            CLABE = ""
        }
        
        phone = GSSISessionInfo.sharedInstance.gsUser.phone?.tryToAdCellphoneFormat ?? ""
        account =  GSSISessionInfo.sharedInstance.gsUser.mainAccount?.tnuoccaFormat ?? ""
        registerCells()
        setOptions()
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        if #available(iOS 13.0, *) {
            UIApplication.shared.statusBarStyle = .darkContent
        }
    }
    
    func setOptions(){
        if #available(iOS 13.0, *) {
            if credit == false{
                configurations.append(userOptions(title: "CLABE Interbancaria", subTitle: CLABE, image: UIImage(systemName: "square.and.arrow.up"), tag: 4))
                configurations.append(userOptions(title: "Número de cuenta", subTitle: "9567 1660 1234 87", image: nil))
                configurations.append(userOptions(title: "Celular asociado", subTitle: phone, image: nil))
                configurations.append(userOptions.init(title: "Estados de cuenta", subTitle: nil, image: UIImage(systemName: "chevron.right"), tag: 1))
                configurations.append(userOptions.init(title: "Límites", subTitle: nil, image: UIImage(systemName: "chevron.right"), tag: 2))
                configurations.append(userOptions.init(title: "Beneficiarios", subTitle: nil, image: UIImage(systemName: "chevron.right"), tag: 3))
            }else{
                configurations.append(userOptions(title: "Número de tarjeta física", subTitle: CLABE, image: UIImage(systemName: "doc.fill"), tag: 5))
                configurations.append(userOptions.init(title: "Estado de cuenta", subTitle: nil, image: UIImage(systemName: "chevron.right"), tag: 1))
            }
        }
    }
    
    func registerCells(){
        let bundle = Bundle.init(for: BASACardConfigViewController.self)
        table.register(UINib(nibName: "RequestCardCell", bundle: bundle), forCellReuseIdentifier: "RequestCardCell")
        table.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        table.register(UINib(nibName: "ConfigItemCell", bundle: bundle), forCellReuseIdentifier: "ConfigItemCell")
        table.register(UINib(nibName: "BASACardControl", bundle: bundle), forCellReuseIdentifier: "BASACardControl")
    }
    
    @objc func turnOnCard(sender: UISwitch){
        if sender.isOn{
            GSVCLoader.show(type: .native)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                GSVCLoader.hide()
                let alert = UIAlertController(title: "Apagaste tu tarjeta", message: "Las nuevas compras no serán procesadas. Puedes volver a encenderla cuando lo necesites. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }else{
            GSVCLoader.show(type: .native)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                GSVCLoader.hide()
                let alert = UIAlertController(title: "Encendiste tu tarjeta", message: "Las nuevas compras serán procesadas. Puedes volver a apagarla cuando lo necesites. ", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
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
            return  configurations.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if credit == true{
            switch indexPath.row{
            case 0:
                let cell = table.dequeueReusableCell(withIdentifier: "BASACardControl") as! BASACardControl
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
            switch indexPath.row{
            case 0:
                let cell = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
                cell.lblTitle.text = "Información"
                return cell
            default:
                let cell = table.dequeueReusableCell(withIdentifier: "ConfigItemCell") as! ConfigItemCell
                let data = configurations[indexPath.row - 1]
                cell.tag = data.tag ?? -1
                cell.configureCell(title: data.title, subtitle: data.subTitle, image: data.image)
                return cell
            }
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
            switch indexPath.row{
            case 0:
                return 60.0
            default:
                return 75.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath)
        switch cell!.tag{
        case 1:
            var view = UIViewController()
            if credit == true{
                view = BASACardStatementsRouter.createModule(type: .credit)
            }else{
                view = BASACardStatementsRouter.createModule(type: .debit)
            }
            self.navigationController?.pushViewController(view, animated: true)
        case 2:
            let view = BASACardLimitsRouter.createModule()
            self.navigationController?.pushViewController(view, animated: true)
        case 3:
             let view = BASABeneficiaryListRouter.createModule()
             self.navigationController?.pushViewController(view, animated: true)
//            let verification = GSVTDigitalSignViewController(delegate: self, dataSource: nil)
//            verification.modalPresentationStyle = .fullScreen
//            present(verification, animated: true, completion: nil)
        case 4:
            let text = "Mi número de cuenta CLABE para enviarme dinero desde otro banco (SPEI) es: \(CLABE ?? "") \nMi número de cuenta para enviarme dinero dentro de baz es: \(account) \nMi número de celular asociado para envíos es: \(phone)"
            let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        case 5:
            self.presentBottomAlertFullData(status: .success, message: "Número de cuenta copiado", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            UIPasteboard.general.string = CLABE
        default:
            print("default case...")
        }
    }
}

