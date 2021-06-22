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

class BASACardConfigViewController: UIViewController, BASACardConfigViewProtocol {
    
    var presenter: BASACardConfigPresenterProtocol?
    var credit: Bool!
    
    @IBOutlet weak var table: UITableView!
    
    struct userOptions {
        var title: String
        var subTitle: String?
        var image: UIImage?
        var tag: Int?
    }
    
    var configurations: Array<userOptions> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            configurations.append(userOptions(title: "CLABE Interbancaria", subTitle: "1271 8099 7700 1123 98", image: UIImage(systemName: "square.and.arrow.up")))
            configurations.append(userOptions(title: "Número de cuenta", subTitle: "9567 1660 1234 87", image: nil))
            configurations.append(userOptions(title: "Celular asociado", subTitle: "55 1234 5678", image: nil))
            configurations.append(userOptions.init(title: "Estado de cuenta", subTitle: nil, image: UIImage(systemName: "chevron.right"), tag: 1))
            configurations.append(userOptions.init(title: "Límites de la tarjeta", subTitle: nil, image: UIImage(systemName: "chevron.right"), tag: 2))
            configurations.append(userOptions.init(title: "Beneficiarios", subTitle: nil, image: UIImage(systemName: "chevron.right"), tag: 3))
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
                let cell = table.dequeueReusableCell(withIdentifier: "RequestCardCell")
                return cell!
            case 1:
                let cell = table.dequeueReusableCell(withIdentifier: "SectionCell")
                return cell!
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
                let cell = table.dequeueReusableCell(withIdentifier: "SectionCell")
                return cell!
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
                return 119.0
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
            let view = BASACardStatementsRouter.createModule()
            self.navigationController?.pushViewController(view, animated: true)
        case 2:
            let view = BASACardLimitsRouter.createModule()
            self.navigationController?.pushViewController(view, animated: true)
        case 3:
            let view = BASABeneficiaryListRouter.createModule()
            self.navigationController?.pushViewController(view, animated: true)
        default:
            print("default case...")
        }
    }
}

