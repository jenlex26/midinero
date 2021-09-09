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
import GSSASessionInfo

class BASACardStatementsViewController: UIViewController, BASACardStatementsViewProtocol, GSVCBottomAlertHandler{
    
    @IBOutlet weak var table: UITableView!
    
    struct statement{
        var title: String
        var subTitle: String?
        var switchState: Bool?
        var tag: Int?
    }
    
    var statements: Array<statement> = []
    var requestData: [StatementDetail] = []
    var bottomAlert: GSVCBottomAlert?
    var presenter: BASACardStatementsPresenterProtocol?
    var type: CardType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        self.setBackButtonForOlderDevices(tint: .purple)
        if type == .debit{
            tagCardStatementsViewDidAppear(credit: false)
            GSVCLoader.show()
            let requestBody = DebitCardStatementBody(numeroCuenta: "", fechaInicio: "", fechaFin: "")
            presenter?.requestStatements(body: requestBody, StatementsResultData: { [self] StatementsResultData in
                if StatementsResultData != nil{
                    requestData = StatementsResultData?.resultado?.detalles ?? []
                    setStatements()
                }else{
                    showEmptyStatementsView()
                }
                GSVCLoader.hide()
            })
        }
        
        if type == .credit{
            tagCardStatementsViewDidAppear(credit: true)
            print("NOT IMPLEMENTED...")
            setStatements()
        }
    }
    
    func setStatements(){
        statements.append(statement.init(title: "Seleccionar todos", subTitle: nil, tag: 0))
        var index = 1
        for item in requestData{
            let title = item.fechaFin?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "MMMM yyyy")
            let initialDate = item.fechaInicio?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMMM") ?? ""
            let finalDate = item.fechaFin?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMMM") ?? ""
            statements.append(statement(title: title ?? "", subTitle: initialDate + " - " + finalDate, tag: index))
            index += 1
        }
        table.reloadData()
        
        if requestData.count == 0{
            showEmptyStatementsView()
        }
        
    }
    
    func registerCells(){
        let bundle = Bundle(for: BASACardStatementsViewController.self)
        table.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        table.register(UINib(nibName: "BASAInfoCardCell", bundle: bundle), forCellReuseIdentifier: "BASAInfoCardCell")
        table.register(UINib(nibName: "BASASwitchItemCell", bundle: bundle), forCellReuseIdentifier: "BASASwitchItemCell")
        table.register(UINib(nibName: "BASAButtonCell", bundle: bundle), forCellReuseIdentifier: "BASAButtonCell")
    }
    
    func optionalAction() {
        print("OK")
    }
    
    func sendStatements(){
        if type == .credit{
            tagSendStatementsButtonClick(origin: "credito")
        }else{
            tagSendStatementsButtonClick(origin: "debito")
        }
        
        
        table.selectRow(at: [0,3], animated: true, scrollPosition: .middle)
        table.delegate?.tableView!(table, didSelectRowAt: [0,3])
        
        //        let success = GSVTOperationStatusViewController(status: .success(title: "Operación completada", message: "Estados de cuenta envíados", views: []), plainButtonAction: {
        //            self.dismiss(animated: true, completion: {
        //                GSVCLoader.hide()
        //                self.navigationController?.popViewController(animated: true)
        //            })
        //        })
        //        success.modalPresentationStyle = .fullScreen
        //        self.present(success, animated: true, completion: nil)
    }
    
    func cerraBottomAlert() {
        bottomAlert = nil
    }
    
    func showEmptyStatementsView(){
        let view =  UINib(nibName: "GSSAEmptyStatements", bundle: Bundle(for: BASACardStatementsViewController.self)).instantiate(withOwner: nil, options: nil)[0] as! UIView
        if view.subviews[1] is UIButton{
            let button = view.subviews[1] as! GSVCButton
            button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        }
        view.frame = self.view.frame
        table.addSubview(view)
    }
    
    @objc func selectAllStatements(sender: UISwitch){
        activityObserved()
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
        activityObserved()
        statements[0].switchState = false
        statements[sender.tag].switchState = sender.isOn
        if sender.isOn == false{
            let cell = self.table.cellForRow(at: [0,2]) as! BASASwitchItemCell
            cell.swtch.isOn = false
        }
    }
    
    @objc func nextAction(sender: UIButton){
        activityObserved()
        var statementsSelected = false
        for n in 0..<statements.count{
            if statements[n].switchState == true{
                statementsSelected = true
            }
        }
        
        if statementsSelected == true{
            sendStatements()
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
            //cell.lblTitle.text = "Se enviarán al correo electrónico \(GSSISessionInfo.sharedInstance.gsUser.email ?? "")"
            cell.lblTitle.text = "Tu estado de cuenta se encuentra protegido. La contraseña para visualizarlo son los últimos 4 dígitos de tu numero de cuenta"
            cell.lblSubTitle.text = ""
            cell.lblTitle.numberOfLines = 3
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
            cell.tag = data.tag ?? -1
            cell.configureCell(title: data.title, subtitle: data.subTitle)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 40.0
        case 1:
            return 90.0
        case statements.count + 2:
            return 90.0
        case statements.count + 3:
            return 100.0
        default:
            return 75.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityObserved()
        if table.cellForRow(at: indexPath) is BASASwitchItemCell{
            let cell = table.cellForRow(at: indexPath) as! BASASwitchItemCell
            if cell.tag != 0{
                let data = requestData[cell.tag - 1]
                GSVCLoader.show()
                let body = RequestDocumentBody.init(primerTokenVerificacion: customToken.shared.firstVerification, referencia: GSSISessionInfo.sharedInstance.gsUser.mainAccount?.formatToTnuocca14Digits().encryptAlnova() ?? "", periodo: data.periodo ?? "")
                
               // let testBody = RequestDocumentBody.init(primerTokenVerificacion: customToken.shared.firstVerification, referencia: "01180100151815".encryptAlnova(), periodo: "21-01")
                
                presenter?.requestDocument(body: body, Document: { Document in
                    if Document != nil{
                        let view = GSSADocumentReaderRouter.createModule(base64Document: Document?.resultado?.documento ?? "")
                        self.navigationController?.pushViewController(view, animated: true)
                    }else{
                        self.presentBottomAlertFullData(status: .error, message: "Ocurrió un problema al consultar su estado de cuenta, intente más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
                    }
                    GSVCLoader.hide()
                })
            }
        }
    }
}
