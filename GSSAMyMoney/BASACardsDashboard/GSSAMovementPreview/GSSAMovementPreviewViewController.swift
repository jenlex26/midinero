//
//  GSSAMovementPreviewViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 13/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAFunctionalUtilities
import GSSASessionInfo

class GSSAMovementPreviewViewController: UIViewController, GSSAMovementPreviewViewProtocol {
    
    var presenter: GSSAMovementPreviewPresenterProtocol?
    
    @IBOutlet weak var tableContainer : UIView!
    @IBOutlet weak var lblTitle       : GSVCLabel!
    @IBOutlet weak var lblAmount      : GSVCLabel!
    @IBOutlet weak var lblDate        : GSVCLabel!
    @IBOutlet weak var btnArrow       : UIButton!
    @IBOutlet weak var btnClose       : UIButton!
    @IBOutlet weak var btnShare       : UIButton!
    @IBOutlet weak var btnArrowLeft   : UIButton!
    @IBOutlet weak var table          : UITableView!
    @IBOutlet weak var buttonStackSize: NSLayoutConstraint!
    
    var cellsArray:  Array<[UITableViewCell:CGFloat]> = []
    //[[DATA:ORDER]:LABEL TITLE]
    // var details: [[String:Int]:String] = [:]
    var details: Array<[String:String]> = []
    var data: DebitCardTransactionItemV2!
    var movementsArray: DebitCardTransactionV2!
    var index: Int!
    var URLBanxico = "https://www.banxico.org.mx/cep/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        btnArrow.makeCircular()
        btnArrowLeft.makeCircular()
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE{
            buttonStackSize.constant = 24
        }
        configureViewForOlderDevices()
        tableContainer.roundCorners(corners: [.topLeft, .topRight], radius: 20.0)
        tableContainer.layoutIfNeeded()
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        registerCells()
        readData(transaction: data)
    }
    
    func configureViewForOlderDevices(){
        if #available(iOS 13.0, *){()}else{
            btnArrow.tintColor = .white
            btnArrow.setImage(UIImage(named: "ChevronRight", in: Bundle.init(for: GSSAMovementPreviewViewController.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
            btnArrow.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
            btnArrowLeft.tintColor = .white
            btnArrowLeft.setImage(UIImage(named: "ChevronLeft", in: Bundle.init(for: GSSAMovementPreviewViewController.self), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate), for: .normal)
            btnArrowLeft.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
            btnShare.setImage(UIImage.shareIcon().withRenderingMode(.alwaysTemplate), for: .normal)
            btnShare.tintColor = .white
            btnShare.imageEdgeInsets = UIEdgeInsets(top: 3.0, left: 3.0, bottom: 3.0, right: 3.0)
            btnClose.setImage(UIImage(named: "close", in: Bundle.init(for: GSSAMovementPreviewViewController.self), compatibleWith: nil), for: .normal)
        }
    }
    
    func registerCells(){
        let bundle = Bundle(for: GSSAMovementPreviewViewController.self)
        table.register(UINib(nibName: "BASAMovementTableViewCell", bundle: bundle), forCellReuseIdentifier: "BASAMovementCell")
        table.register(UINib(nibName: "BASAInfoCardCell", bundle: bundle), forCellReuseIdentifier: "BASAInfoCardCell")
        table.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
    }
    
    func setOptions(SPEI: Bool){
        for element in details{
            let cell = table.dequeueReusableCell(withIdentifier: "BASAMovementCell") as! BASAMovementTableViewCell
            cell.imgView.isHidden = true
            cell.lblAmount.isHidden = true
            cell.amountSize.constant = -10
            cell.lblTitle.text = element.first?.key
            cell.lblTitle.styleType = 8
            cell.lblTitle.textColor = .darkGray
            cell.lblDate.text = element.first?.value
            cell.lblDate.numberOfLines = 3
            cell.lblDate.styleType = 6
            cell.lblDate.textColor = .black
            
            if element.first?.value.removeWhiteSpaces() != ""{
                if element.first?.value.contains("Nombre del beneficiario") == true{
                    cellsArray.append([cell:105.0])
                }else if element.first?.key == "Ordenante" {
                    cellsArray.append([cell:90.0])
                }else if element.first?.value.count ?? 0 > 25 && UIDevice.current.screenType == .iPhones_5_5s_5c_SE{
                    cellsArray.append([cell:90.0])
                }else if element.first?.value.count ?? 0 > 30{
                    cellsArray.append([cell:90.0])
                }else{
                    cellsArray.append([cell:75.0])
                }
            }
        }
        
        
        //cellsArray = cellsArray.sorted(by: { ($0.first?.key as! BASAMovementTableViewCell).tag  < ($1.first?.key as! BASAMovementTableViewCell).tag })
        
        
        if SPEI == true{
            let sectionCell =  table.dequeueReusableCell(withIdentifier: "SectionCell")!
            sectionCell.isHidden = true
            cellsArray.append([sectionCell:30.0])
            
            let cardInfo = table.dequeueReusableCell(withIdentifier: "BASAInfoCardCell") as! BASAInfoCardCell
            cardInfo.lblText.text = "Consulta el estatus en: \nhttps://www.banxico.org.mx/cep/"
            cardInfo.tag = 1
            cellsArray.append([cardInfo:81.0])
            
            let secondCard = table.dequeueReusableCell(withIdentifier: "BASAInfoCardCell") as! BASAInfoCardCell
            secondCard.lblText.text = "Este vínculo se activará a más tardar dentro de los primeros 5 minutos siguientes de la aceptación de la operación."
            cellsArray.append([secondCard:121.0])
        }
        self.table.reloadData()
    }
    
    func readData(transaction: DebitCardTransactionItemV2){
        cellsArray.removeAll()
        details.removeAll()
        self.table.reloadData()
        
        if index == 0{
            btnArrowLeft.isHidden = true
        }else{
            btnArrowLeft.isHidden = false
        }
        
        if ((movementsArray.resultado?.movimientos?.count ?? 0) - (index ?? 0)) == 1{
            btnArrow.isHidden = true
        }else{
            btnArrow.isHidden = false
        }
        
        lblAmount.text = transaction.importe?.alnovaDecrypt().removeWhiteSpaces().moneyFormatWithoutSplit()
        lblDate.text = transaction.fecha?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMM yyyy")
        
        lblTitle.text = transaction.concepto?.alnovaDecrypt()
        
        //AB2 TIEMPO AIRE
        if transaction.idOperacion == "AB2"{
            let lastAccountDigits = GSSISessionInfo.sharedInstance.gsUser.account?.number?.removeWhiteSpaces().suffix(4)
            details.append(["Realizado con":"Baz****\(lastAccountDigits ?? "")"])
            details.append(["Para": transaction.descripcion?.showOnlyNumbers.withCellphoneFormat ?? ""])
            details.append(["Compañia": transaction.descripcion?.components(separatedBy: " ").last ?? ""])
            details.append(["Fecha":(transaction.fecha?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMM yyyy") ?? "")])
            details.append(["Hora":(data.hora?.timeFormatter() ?? "")])
        }else{
                        if transaction.idOperacion != "212" && transaction.idOperacion != "213" && transaction.idOperacion != "Z87" && transaction.idOperacion != "Z88"{
                            details.append(["Id de operación":transaction.idOperacion ?? ""])
                            details.append(["Descripción":transaction.concepto?.alnovaDecrypt() ?? ""])
            
                            details.append(["Fecha y hora de registro":(transaction.fecha?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMM yyyy") ?? "") + " " + (data.hora?.timeFormatter() ?? "")])
                        }
        }
        
        if transaction.idOperacion == "Z87" || transaction.idOperacion == "Z88"{
            let lastAccountDigits = GSSISessionInfo.sharedInstance.gsUser.account?.number?.removeWhiteSpaces().suffix(4)
            if transaction.idOperacion == "Z87"{
                details.append(["Realizado con":"Baz****\(lastAccountDigits ?? "")"])
                details.append(["Desde ": transaction.descripcion ?? ""])
            }else{
                details.append(["Cuenta":"Baz****\(lastAccountDigits ?? "")"])
                details.append(["Para":transaction.descripcion ?? ""])
            }
            details.append(["Tipo de operación": transaction.concepto ?? ""])
            details.append(["Fecha y hora de registro":(transaction.fecha?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMM yyyy") ?? "") + " " + (data.hora?.timeFormatter() ?? "")])
            details.append(["Folio":transaction.numeroOperacion ?? ""])
        }
        
        details.append(["Folio":transaction.folio ?? ""])
        
        if transaction.idOperacion != "212" && transaction.idOperacion != "213" && transaction.idOperacion != "Z87" && transaction.idOperacion != "Z88"{
            details.append(["Número de operación":transaction.numeroOperacion ?? ""])
        }
        
        let descriptionData = transaction.descripcionOperacion?.components(separatedBy: "|")
        let urlFotoData = transaction.urlFoto?.components(separatedBy: "|")
        
        if descriptionData?.count ?? 0 >= 2{
            if descriptionData![1] == "r"{
                let amount = transaction.importe?.alnovaDecrypt().removeWhiteSpaces()
                lblAmount.text = String((Double(amount ?? "0.0") ?? 0.0) * -1.0).moneyFormatWithoutSplit()
                details.append(["Estatus":"MOV. PENDIENTE"])
            }
        }else{
            if urlFotoData![1] == "r"{
                let amount = transaction.importe?.alnovaDecrypt().removeWhiteSpaces()
                lblAmount.text = String((Double(amount ?? "0.0") ?? 0.0) * -1.0).moneyFormatWithoutSplit()
                details.append(["Estatus":"MOV. PENDIENTE"])
            }
        }
        
        //212 - 213 SPEI
        if transaction.idOperacion == "212" || transaction.idOperacion == "213"{
            URLBanxico = "https://www.banxico.org.mx/cep/"
            //if GLOBAL_ENVIROMENT == .develop{
            GSVCLoader.show()
            let type = lblAmount.text!.contains("-") ? "E" : "R"
            let body = SPEIDetailBody.init(transaccion: SPEIDetailTransaccion.init(claveInstitucionBancaria: GSSISessionInfo.sharedInstance.gsUser.account?.number?.formatToTnuocca14Digits().encryptAlnova(), operacion: SPEIDetailOperacion.init(tipo: type, fecha: transaction.fecha, hora: transaction.numeroOperacion)))
            
            presenter?.requestGetSPEIDetail(Body: body, claveRastreo: transaction.descripcion ?? "", Response: {  [self] Response in
                if Response != nil{
                    let data = Response?.resultado
                    
                    let originData = data?.numeroCuentaOrigen?.components(separatedBy: "|")
                    let destinationData = data?.importeBeneficiario?.components(separatedBy: "|")
                    let referenceData = data?.nombreBeneficiario?.components(separatedBy: "|")
                    let URLData = data?.urlEstatusTransferencia?.components(separatedBy: "|")
                        
                    if myMoneyFrameworkSettings.shared.showV2SPEIDetail == true{
                       // details.updateValue("Ordenante", forKey: [(originData?[0].nameFormatter() ?? "") + "\n" + (originData?[1] ?? ""):12])
                        details.append(["Para":"Nombre del beneficiario\n" + (destinationData?[0] ?? "") + "\n" + "*Dato no verificado por esta institución*"])
                        details.append(["Institución receptora****":((destinationData?[1].components(separatedBy: "-").last?.removeWhiteSpaces() ?? "") + " " + (destinationData?[2].maskedAccount ?? ""))])
                        details.append(["Concepto":referenceData?[1] ?? ""])
                        details.append(["Folio":referenceData?[2] ?? ""])
                        details.append(["Clave de rastreo": (referenceData?[3] ?? "")])
                        details.append(["Fecha":(referenceData?[4] ?? "") + " " + (referenceData?[5] ?? "")])
                        
                        switch data?.estatusTransferencia{
                        case "T":
                            details.append(["Estatus de transferencia":"Liquidada"])
                        case "APLICADA":
                            details.append(["Estatus de transferencia":"Aplicada"])
                        case "C":
                            details.append(["Estatus de transferencia":"Liquidada por contingencia"])
                        case "D":
                            details.append(["Estatus de transferencia":"Devuelta"])
                        case .none:
                            details.append(["Estatus de transferencia":""])
                        case .some(_):
                            details.append(["Estatus de transferencia":""])
                        }
                        
                        details.append(["Referencia":referenceData?[0] ?? ""])
                        
                        if URLData?.count ?? 0 >= 3{
                            URLBanxico = "https://www.banxico.org.mx/cep/go?i=" + URLData![0]
                            URLBanxico = URLBanxico + "&s=" + URLData![1]
                            URLBanxico = URLBanxico + "&d=" + (URLData?[2].alnovaDecrypt().removeWhiteSpaces().replacingOccurrences(of: "\r\n", with: ""))!
                        }
                    }else{
                        details.append(["Clave de rastreo":(referenceData?[3] ?? "")])
                        details.append(["Ordenante":(originData?[0].nameFormatter() ?? "") + "\n" + (originData?[1] ?? "")])
                        details.append(["Referencia":referenceData?[0] ?? ""])
                        details.append(["Concepto ":referenceData?[1] ?? ""])
                        details.append(["Nombre del beneficiario":(destinationData?[0] ?? "") + "\nCuenta: " + (destinationData?[1] ?? "")])
                        
                        switch data?.estatusTransferencia{
                        case "T":
                            details.append(["Estatus de transferencia":"Liquidada"])
                        case "APLICADA":
                            details.append(["Estatus de transferencia":"Aplicada"])
                        case "C":
                            details.append(["Estatus de transferencia":"Liquidada por contingencia"])
                        case "D":
                            details.append(["Estatus de transferencia":"Devuelta"])
                        case .none:
                            details.append(["Estatus de transferencia":""])
                        case .some(_):
                            details.append(["Estatus de transferencia":""])
                        }
                        
                        details.append(["Descripción":transaction.concepto?.alnovaDecrypt() ?? ""])
                        details.append(["Id de operación":transaction.idOperacion ?? ""])
                        
                        if URLData?.count ?? 0 >= 3{
                            URLBanxico = "https://www.banxico.org.mx/cep/go?i=" + URLData![0]
                            URLBanxico = URLBanxico + "&s=" + URLData![1]
                            URLBanxico = URLBanxico + "&d=" + (URLData?[2].alnovaDecrypt().removeWhiteSpaces().replacingOccurrences(of: "\r\n", with: ""))!
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    GSVCLoader.hide()
                })
                setOptions(SPEI: true)
            })
        }else{
            setOptions(SPEI: false)
        }
    }
    
    func share(_ shouldSave: Bool = false) -> UIImage? {
        var screenshotImage :UIImage?
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        layer.render(in:context)
        screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = screenshotImage, shouldSave {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        return screenshotImage
    }
    
    @IBAction func close(_ sender: Any){
        activityObserved()
        self.dismiss(animated: true, completion: nil)
        // self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func share(_ sender: Any){
        activityObserved()
        let image = share()
        let imageToShare = [ image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func previousMovement(_ sender: Any){
        let array = movementsArray.resultado?.movimientos
        if index < array?.count ?? 0 && index >= 0{
            index -= 1
            readData(transaction: (array?[index])!)
        }
    }
    
    @IBAction func nextMovement(_ sender: Any){
        let array = movementsArray.resultado?.movimientos
        if index < array?.count ?? 0 || index > array?.count ?? 0{
            index += 1
            readData(transaction: (array?[index])!)
        }
    }
}

extension GSSAMovementPreviewViewController: UITableViewDelegate, UITableViewDataSource{
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
        let cell = table.cellForRow(at: indexPath)
        activityObserved()
        switch cell?.tag{
        case 1:
            if let url = URL(string: "\(URLBanxico)") {
                UIApplication.shared.open(url)
            }
        case .none:
            ()
        case .some(_):
            ()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        activityObserved()
    }
}

