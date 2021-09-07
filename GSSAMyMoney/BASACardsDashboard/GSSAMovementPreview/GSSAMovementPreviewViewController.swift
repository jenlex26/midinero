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
    var details: [String:String] = [:]
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
        if #available(iOS 13.0, *){}else{
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
            cell.lblTitle.text = element.value
            cell.lblTitle.styleType = 8
            cell.lblDate.text = element.key
            cell.lblDate.numberOfLines = 2
            cell.lblDate.styleType = 6
            if element.key.removeWhiteSpaces() != ""{
                if element.value == "Nombre del beneficiario" || element.value == "Ordenante"{
                    cellsArray.append([cell:90.0])
                }else{
                    cellsArray.append([cell:75.0])
                }
            }
        }
        cellsArray = cellsArray.sorted(by: { ($0.first?.key as! BASAMovementTableViewCell).lblTitle.text!  < ($1.first?.key as! BASAMovementTableViewCell).lblTitle.text! })
        
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
        
        details.updateValue("Descripción", forKey: transaction.concepto?.alnovaDecrypt() ?? "")
        //details.updateValue("Realizado", forKey: transaction.nombreOrdenante ?? "")
        //details.updateValue("Para", forKey:  transaction.descripcionBeneficiario ?? "")
        details.updateValue("Id de operación", forKey: transaction.idOperacion ?? "")
        details.updateValue("Folio", forKey: transaction.folio ?? "")
        details.updateValue("Número de operación", forKey: transaction.numeroOperacion ?? "")
        details.updateValue("Fecha y hora de registro", forKey: (transaction.fecha?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMM yyyy") ?? "") + " " + (data.hora?.timeFormatter() ?? ""))
        
        let descriptionData = transaction.descripcionOperacion?.components(separatedBy: "|")
        let urlFotoData = transaction.urlFoto?.components(separatedBy: "|")
        var claveInstitucion = ""
        
        if descriptionData?.count ?? 0 >= 2{
            if descriptionData![0].count >= 4{
                claveInstitucion = descriptionData![0].suffix(4).description
            }
            
            if descriptionData![1] == "r"{
                let amount = transaction.importe?.alnovaDecrypt().removeWhiteSpaces()
                lblAmount.text = String((Double(amount ?? "0.0") ?? 0.0) * -1.0).moneyFormatWithoutSplit()
                details.updateValue("Estatus", forKey: "MOV. PENDIENTE")
            }
        }else{
            if urlFotoData![0].count >= 4{
                claveInstitucion = urlFotoData![0].suffix(4).description
            }
            
            if urlFotoData![1] == "r"{
                let amount = transaction.importe?.alnovaDecrypt().removeWhiteSpaces()
                lblAmount.text = String((Double(amount ?? "0.0") ?? 0.0) * -1.0).moneyFormatWithoutSplit()
                details.updateValue("Estatus", forKey: "MOV. PENDIENTE")
            }
        }
        
        
        if transaction.idOperacion == "212" || transaction.idOperacion == "213"{
            URLBanxico = "https://www.banxico.org.mx/cep/"
            //if GLOBAL_ENVIROMENT == .develop{
            GSVCLoader.show()
            let type = lblAmount.text!.contains("-") ? "E" : "R"
            let body = SPEIDetailBody.init(transaccion: SPEIDetailTransaccion.init(claveInstitucionBancaria: GSSISessionInfo.sharedInstance.gsUser.mainAccount?.formatToTnuocca14Digits().encryptAlnova(), operacion: SPEIDetailOperacion.init(tipo: type, fecha: transaction.fecha, hora: transaction.numeroOperacion)))
            
            presenter?.requestGetSPEIDetail(Body: body, claveRastreo: transaction.descripcion ?? "", Response: {  [self] Response in
                if Response != nil{
                    
                    let data = Response?.resultado
                    
                    let originData = data?.numeroCuentaOrigen?.components(separatedBy: "|")
                    
                    details.updateValue("Clave de rastreo", forKey: transaction.descripcion ?? "")
                    details.updateValue("Ordenante", forKey: (originData?[0] ?? "") + "\n" + (originData?[1] ?? ""))
                    
                    let destinationData = data?.importeBeneficiario?.components(separatedBy: "|")
                    
                    let referenceData = data?.nombreBeneficiario?.components(separatedBy: "|")
                    
                    details.updateValue("Referencia", forKey: referenceData?[0] ?? "")
                    details.updateValue("Concepto ", forKey: referenceData?[1] ?? "")
                    
                    details.updateValue("Nombre del beneficiario", forKey: (destinationData?[0] ?? "") + "\nCuenta: " + (destinationData?[1] ?? ""))
                    
                    switch data?.estatusTransferencia{
                    case "T":
                        details.updateValue("Estatus de transferencia", forKey: "Liquidada")
                    case "C":
                        details.updateValue("Estatus de transferencia", forKey: "Liquidada por contingencia")
                    case .none:
                        details.updateValue("Estatus de transferencia", forKey: "")
                    case .some(_):
                        details.updateValue("Estatus de transferencia", forKey: "")
                    }
                    
                    let URLData = data?.urlEstatusTransferencia?.components(separatedBy: "|")
                    
                    if URLData?.count ?? 0 >= 3{
                        URLBanxico = "https://www.banxico.org.mx/cep/go?i=" + URLData![0]
                        URLBanxico = URLBanxico + "&s=" + URLData![1]
                        URLBanxico = URLBanxico + "&d=" + (URLData?[2].removeWhiteSpaces())!
                    }
                }
                GSVCLoader.hide()
                setOptions(SPEI: true)
            })
            //            }else{
            //                setOptions(SPEI: true)
            //            }
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
            print("INDEX \(index ?? -29) CONTEO \(array?.count ?? -3) <")
            index -= 1
            readData(transaction: (array?[index])!)
        }
    }
    
    @IBAction func nextMovement(_ sender: Any){
        let array = movementsArray.resultado?.movimientos
        print("INDEX \(index ?? -29) CONTEO \(array?.count ?? -3) >")
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
            print("None case")
        case .some(_):
            print("Some")
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        activityObserved()
    }
}
