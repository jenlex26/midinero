//
//  BASABeneficiaryListViewController.swift
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

class BASABeneficiaryListViewController: UIViewController, BASABeneficiaryListViewProtocol, GSVCBottomAlertHandler {
    
    @IBOutlet weak var table: UITableView!
    
    var bottomAlert: GSVCBottomAlert?
	var presenter: BASABeneficiaryListPresenterProtocol?
    var tableData: [BeneficiaryItem] = []
    
	override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        registerCells()
        loadBeneficiaries()
    }
    
    func registerCells(){
        table.register(UINib(nibName: "BASACardLimitCell", bundle: Bundle.init(for: BASACardLimitsViewController.self)), forCellReuseIdentifier: "BASACardLimitCell")
        table.register(UINib(nibName: "BeneficiaryButtonCell", bundle: Bundle.init(for: BeneficiaryButtonCell.self)), forCellReuseIdentifier: "BeneficiaryButtonCell")
    }
    
    func optionalAction() {
        print("alert closed")
    }
    
    func loadBeneficiaries(){
        GSVCLoader.show(type: .native)
        presenter?.requestBeneficiaries(account: GSSISessionInfo.sharedInstance.gsUser.mainAccount ?? "", beneficiaryList: { [self] beneficiaryList in
            GSVCLoader.hide()
            if beneficiaryList?.resultado?.beneficiarios != nil{
                for item in beneficiaryList!.resultado!.beneficiarios!{
                    tableData.append(item)
                    self.table.reloadData()
                }
            }else{
                self.presentBottomAlertFullData(status: .error, message: "No podemos cargar tus beneficiarios en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        })
        
        
    }
    
    @objc func newBeneficiary(_ sender: Any){
        let view = BASANewBeneficiaryRouter.createModule()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

extension BASABeneficiaryListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableData.count == 4{
            return tableData.count
        }else{
            return tableData.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == tableData.count && tableData.count < 4{
            let cell = table.dequeueReusableCell(withIdentifier: "BeneficiaryButtonCell") as! BeneficiaryButtonCell
            cell.button.addTarget(self, action: #selector(newBeneficiary(_:)), for: .touchUpInside)
            return cell
        }else{
            let cell = table.dequeueReusableCell(withIdentifier: "BASACardLimitCell") as! BASACardLimitCell
            let cellData = tableData[indexPath.row]
            let userName = (cellData.nombre?.alnovaDecrypt().replacingOccurrences(of: " ", with: "") ?? "") + " " + (cellData.apellidoPaterno?.alnovaDecrypt().replacingOccurrences(of: " ", with: "") ?? "") + " " + (cellData.apellidoMaterno?.alnovaDecrypt().replacingOccurrences(of: " ", with: "") ?? "")
            cell.lblTitle.text = userName
            cell.lblSubtitle.text = (cellData.porcentaje?.alnovaDecrypt() ?? "0") + "%"
            cell.btnEdit.isEnabled = false
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == tableData.count && tableData.count < 4{
            return 100.0
        }else{
            return 75.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = table.cellForRow(at: indexPath)
        if cell is BASACardLimitCell{
            let view = BASANewBeneficiaryRouter.createModuleForActiveItem(data: tableData[indexPath.row])
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
