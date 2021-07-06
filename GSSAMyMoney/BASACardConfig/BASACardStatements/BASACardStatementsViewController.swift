//
//  BASACardStatementsViewController.swift
//  GSSAFront
//
//  Created Desarrollo on 13/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates

class BASACardStatementsViewController: UIViewController, BASACardStatementsViewProtocol, GSVTGenericResultDelegate, GSVCBottomAlertHandler, GSVTDigitalSignDelegate {
    
    var bottomAlert: GSVCBottomAlert?
    var presenter: BASACardStatementsPresenterProtocol?
    var type: CardType!
    
    @IBOutlet weak var table: UITableView!
    
    struct statement{
        var title: String
        var subTitle: String?
        var switchState: Bool?
        var tag: Int?
    }
    
    var statements: Array<statement> = []
    var requestData: [StatementDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        
        if type == .debit{
            GSVCLoader.show(type: .native)
            let requestBody = DebitCardStatementBody(numeroCuenta: "974563210", fechaInicio: "10-10-2020", fechaFin: "10-12-2020")
            presenter?.requestStatements(body: requestBody, StatementsResultData: { [self] StatementsResultData in
                GSVCLoader.hide()
                if StatementsResultData != nil{
                    requestData = StatementsResultData?.resultado?.detalles ?? []
                    setStatements()
                }else{
                    self.presentBottomAlertFullData(status: .error, message: "No podemos cargar tus estados de cuenta en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
                }
            })
        }
        
        if type == .credit{
            print("NOS IMPLEMENTED...")
            setStatements()
        }
    }
    
    func setStatements(){
        statements.append(statement.init(title: "Seleccionar todos", subTitle: nil, tag: 0))
        var index = 1
        for item in requestData{
            let title = item.fechaFin?.dateFormatter(format: "dd-MM-yyyy", outputFormat: "MMMM yyyy")
            let initialDate = item.fechaInicio?.dateFormatter(format: "dd-MM-yyyy", outputFormat: "dd MMMM") ?? ""
            let finalDate = item.fechaFin?.dateFormatter(format: "dd-MM-yyyy", outputFormat: "dd MMMM") ?? ""
            statements.append(statement(title: title ?? "", subTitle: initialDate + " - " + finalDate, tag: index))
            index += 1
        }
        table.reloadData()
        
        if requestData.count == 0{
            let view =  UINib(nibName: "GSSAEmptyStatements", bundle: Bundle(for: BASACardStatementsViewController.self)).instantiate(withOwner: nil, options: nil)[0] as! UIView
            if view.subviews[1] is UIButton{
                let button = view.subviews[1] as! GSVCButton
                button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
            }
            view.frame = self.view.frame
            table.addSubview(view)
        }
        
    }
    
    func registerCells(){
        let bundle = Bundle(for: BASACardStatementsViewController.self)
        table.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        table.register(UINib(nibName: "BASAInfoCardCell", bundle: bundle), forCellReuseIdentifier: "BASAInfoCardCell")
        table.register(UINib(nibName: "BASASwitchItemCell", bundle: bundle), forCellReuseIdentifier: "BASASwitchItemCell")
        table.register(UINib(nibName: "BASAButtonCell", bundle: bundle), forCellReuseIdentifier: "BASAButtonCell")
    }
    
    func genericResultStaticButtonAction(style: GSVTGenericResultStyle) {
        self.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func optionalAction() {
        print("OK")
    }
    
    func sendStatements(){
        let success = GSVTOperationStatusViewController(status: .success(title: "Operación completada", message: "Estados de cuenta envíados", views: []), plainButtonAction: {
            self.dismiss(animated: true, completion: {
                GSVCLoader.hide()
                self.navigationController?.popViewController(animated: true)
            })
        })
        success.modalPresentationStyle = .fullScreen
        self.present(success, animated: true, completion: nil)
    }
    
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) {
        print("forgott")
    }
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        sendStatements()
    }
    
    func cerraBottomAlert() {
        bottomAlert = nil
    }
    
    @objc func selectAllStatements(sender: UISwitch){
        for n in 0..<statements.count{
            if sender.isOn{
                statements[n].switchState = true
            }else{
                statements[n].switchState = false
            }
        }
        self.table.reloadData()
    }
    
    @objc func stamementSelected(sender: UISwitch){
        statements[0].switchState = false
        statements[sender.tag].switchState = sender.isOn
        if sender.isOn == false{
           let cell = self.table.cellForRow(at: [0,2]) as! BASASwitchItemCell
           cell.swtch.isOn = false
        }
    }
    
    @objc func nextAction(sender: UIButton){
        var statementsSelected = false
        for n in 0..<statements.count{
            if statements[n].switchState == true{
                statementsSelected = true
            }
        }
        
        if statementsSelected == true{
            let verification = GSVTDigitalSignViewController(delegate: self, dataSource: nil)
            verification.modalPresentationStyle = .fullScreen
            present(verification, animated: true, completion: nil)
        }else{
            self.presentBottomAlertFullData(status: .caution, message: "Debe seleccionar al menos un estado de cuenta", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
        }
    }
    
    @objc func closeView(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension BASACardStatementsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statements.count + 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
            cell.lblTitle.text = "Selecciona los estados de cuenta"
            cell.lblTitle.numberOfLines = 2
            return cell
        case 1:
            let cell = table.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
            cell.lblTitle.text = "Se enviarán al correo electrónico lili22@gmail.com"
            cell.lblTitle.numberOfLines = 2
            cell.lblTitle.styleType = 6
            return cell
        case statements.count + 2:
            let cell = table.dequeueReusableCell(withIdentifier: "BASAInfoCardCell")
            return cell!
        case statements.count + 3:
            let cell = table.dequeueReusableCell(withIdentifier: "BASAButtonCell") as! BASAButtonCell
            cell.btnNext.addTarget(self, action: #selector(nextAction(sender:)), for: .touchUpInside)
            return cell
        default:
            let cell = table.dequeueReusableCell(withIdentifier: "BASASwitchItemCell") as! BASASwitchItemCell
            let data = statements[indexPath.row - 2]
            if data.tag == 0{
                cell.backgroundColor = UIColor.GSVCBase300()
                cell.swtch.addTarget(self, action: #selector(selectAllStatements(sender:)), for: .valueChanged)
            }else{
                cell.backgroundColor = .white
                cell.swtch.addTarget(self, action: #selector(stamementSelected(sender:)), for: .valueChanged)
            }
            if data.switchState == true{
                cell.swtch.isOn = true
            }else{
                cell.swtch.isOn = false
            }
            cell.configureCell(title: data.title, subtitle: data.subTitle)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 65.0
        case 1:
            return 70.0
        case statements.count + 2:
            return 110.0
        case statements.count + 3:
            return 119.0
        default:
            return 70.0
        }
    }
}

extension String{
    func dateFormatter(format: String, outputFormat: String) -> String{
        let dateFormatterIn = DateFormatter()
        dateFormatterIn.dateFormat = format
        
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = outputFormat
        dateFormatterOut.locale = Locale(identifier: "es_MX")
        
        let dateIn = dateFormatterIn.date(from: self)
        let dateOut = dateFormatterOut.string(from: dateIn ?? Date())
        
        return dateOut.capitalized
    }
}
