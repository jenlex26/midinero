//
//  BASAMainHubCardsViewController.swift
//  GSSAFront
//
//  Created Andoni Suarez on 15/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSASessionInfo

class BASAMainHubCardsViewController: UIViewController, BASAMainHubCardsViewProtocol, GSVCBottomAlertHandler {
    
    var bottomAlert: GSVCBottomAlert?
    var presenter: BASAMainHubCardsPresenterProtocol?
    var viewMode = 0
    
    @IBOutlet weak var BasaMainHubTableView:UITableView!
    @IBOutlet weak var headerImage: UIImageView!
    
    var cellsArray: Array<[UITableViewCell:CGFloat]> = []
    
    var accountBalance: BalanceResponse?
    var debitCardMovements: DebitCardTransaction?
    var debitCardMovementsV2: DebitCardTransactionV2?
    var lendsData: LendsResponse?
    var creditCardData: CreditCardResponse?
    var creditCardBalance: CreditCardBalanceResponse?
    var creditCardMovements: CreditCardMovementsResponse?
    var accountNumber: [String:String]?
    let refreshControl = GSFMoneyRockaletaControl()
    var headerSize: CGFloat = 300.0 //380.0 Valor para cuando el usuario tiene crédito o prestamos, en caso contrario el predeterminado debería ser 300.0
    var startTime: Date?
    var time: TimeInterval = 300.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializeView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeaderSize(sender:)), name: Notification.Name("creditCardAvailable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateHeaderSize(sender:)), name: Notification.Name("onlyLendsAvaliable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name(rawValue: "externalFlowFinished"), object: nil)
        setUpRefreshControl()
        startTime = Date()
        checkTime()
        self.BasaMainHubTableView.isHidden = true
        createTag(eventName: .pageView, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", origin: "debito")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDebitBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc func reloadView(){
        loadDebitBalance()
    }
    
    func checkTime(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: { [self] in
            if (self.startTime! + time) < Date(){
                self.dismiss(animated: true, completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            }else{
                self.checkTime()
            }
        })
    }
    
    func inicializeView(){
        setUpRefreshControl()
        ConfigureCollectionView()
        self.BasaMainHubTableView.alwaysBounceVertical = false
        NotificationCenter.default.addObserver(self, selector: #selector(SwitchColors(notification:)), name: NSNotification.Name(rawValue: "HomeHeaderViewChange"), object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setTableForDebitCard()
    }
    
    func setUpRefreshControl(){
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        BasaMainHubTableView.addSubview(refreshControl)
    }
    
    func loadDebitBalance(){
        GSVCLoader.show()
        presenter?.requestBalance(Account: [accountNumber?.first?.key.encryptAlnova() ?? (GSSISessionInfo.sharedInstance.gsUser.mainAccount?.encryptAlnova() ?? ""): accountNumber?.first?.value ?? (GSSISessionInfo.sharedInstance.gsUser.SICU?.encryptAlnova() ?? "")], Balance: { Balance in
            if let NewBalance = Balance{
                DispatchQueue.main.async {
                    self.accountBalance = NewBalance
                    UserDefaults.standard.setValue(NewBalance.resultado.cliente?.cuentas?.first?.clabe?.alnovaDecrypt().tnuoccaFormat, forKey: "DebitCardCLABE")
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadHeaderData"), object: NewBalance, userInfo: nil))
                   // self.loadDebitMovements()
                    self.loadDebitMovementsV2()
                }
            }else{
                self.BasaMainHubTableView.isHidden = false
                GSVCLoader.hide()
                self.presentBottomAlertFullData(status: .error, message: "No podemos cargar tu saldo en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadDebitMovements(){
        self.presenter?.requestDebitCardMovements(Body: MovimientosBody(transaccion: MovementsBodyData(numeroCuenta: accountNumber?.first?.key ?? (GSSISessionInfo.sharedInstance.gsUser.mainAccount?.encryptAlnova()), fechaInicial: "01/01/0001", fechaFinal: "01/01/0001")), Movements: { [self] Movements in
            GSVCLoader.hide()
            self.BasaMainHubTableView.isHidden = false
            if Movements != nil{
                debitCardMovements = Movements
                setTableForDebitCard()
                loadActivateCard()
            }else{
                self.presentBottomAlertFullData(status: .error, message: "No podemos cargar tus movimientos en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        })
    }
    
    func loadDebitMovementsV2(){
       // let BodyProdV2 =  MovimientosBodyv2.init(transaccion: MovementsBodyDataV2.init(sicu: GSSISessionInfo.sharedInstance.gsUser.SICU, numeroCuenta:  GSSISessionInfo.sharedInstance.gsUser.mainAccount?.formatToTnuocca14Digits().encryptAlnova(), geolocalizacion: Geolocalizacion.init(latitud: "", longitud: "")))
        
        let BodyDevV2 =  MovimientosBodyv2.init(transaccion: MovementsBodyDataV2.init(sicu: GSSISessionInfo.sharedInstance.gsUser.SICU, numeroCuenta:  "01271156141200001956".formatToTnuocca14Digits().encryptAlnova(), geolocalizacion: Geolocalizacion.init(latitud: "", longitud: "")))
        
        self.presenter?.requestDebitCardMovementsV2(Body: BodyDevV2, Movements: { [self] Movements in
            
            GSVCLoader.hide()
            self.BasaMainHubTableView.isHidden = false
            if Movements != nil{
                
                debitCardMovementsV2 = Movements
                setTableForDebitCard()
                loadActivateCard()
            }else{
                self.presentBottomAlertFullData(status: .error, message: "No podemos cargar tus movimientos en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        })
    }
    
    func loadLends(){
        GSVCLoader.show()
        presenter?.requestUserLends(Lends: { [self]Lends in
            GSVCLoader.hide()
            if let LendsData = Lends{
                lendsData = LendsData
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadLendsData"), object: LendsData, userInfo: nil))
                setTableForLends()
            }else{
                GSVCLoader.hide()
                self.presentBottomAlertFullData(status: .error, message: "No podemos cargar tus prestamos en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadCreditCardInfo(){
        //let numberCard = GSSISessionInfo.sharedInstance.gsUser.card?.dynamicEncrypt()
        
        let numberCard = String(4589090600000345).dynamicEncrypt()
        GSVCLoader.show()
        presenter?.requestCreditCardData(Body: CreditCardBody.init(transaccion: CreditCardTransaccion.init(numeroCuenta: "", numeroTarjeta: numberCard, numeroContrato: "")), CreditCardData: { [self] CreditCardData in
            if let CreditCard = CreditCardData{
                creditCardData = CreditCard
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadCreditCardData"), object: CreditCard, userInfo: nil))
                loadCreditCardBalance()
            }else{
                GSVCLoader.hide()
                self.presentBottomAlertFullData(status: .error, message: "No podemos obtener los datos de la tarjeta en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadCreditCardBalance(){
        presenter?.requestCreditCardBalance(Body: CreditCardBalanceBody.init(transaccion: CreditCardBalanceTransaccion.init(numeroTarjeta: "4589090600000345".dynamicEncrypt())), CreditCardBalance: { [self] CreditCardBalance in
            if let creditCardBalanceResponse = CreditCardBalance{
                creditCardBalance = creditCardBalanceResponse
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadCreditCardBalance"), object: creditCardBalanceResponse, userInfo: nil))
                setTableForCreditCard()
                loadCreditCardMovements()
            }else{
                GSVCLoader.hide()
                self.presentBottomAlertFullData(status: .error, message: "No podemos obtener los saldos de la tarjeta de crédito en este momento, intente más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        })
    }
    
    func loadCreditCardMovements(){
        presenter?.requestCreditCardMovements(Body: CreditCardMovementsBody.init(transaccion: CreditCardMovementsTransaccion.init(fechaInicio: "2021-04-01", fechaFin: "2021-07-01")), CreditCardMovements: { [self] CreditCardMovements in
            GSVCLoader.hide()
            if let CreditCardMovements = CreditCardMovements{
                creditCardMovements = CreditCardMovements
                setTableForCreditCard()
            }else{
                GSVCLoader.hide()
                self.presentBottomAlertFullData(status: .error, message: "No podemos obtener tus movimientos en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        })
    }
    
    func loadActivateCard(){
        presenter?.requestCreditCardBalance(Body: CreditCardBalanceBody.init(transaccion: CreditCardBalanceTransaccion.init(numeroTarjeta: GSSISessionInfo.sharedInstance.gsUser.card?.dynamicEncrypt())), CreditCardBalance: { [self] CreditCardBalance in
            if let creditCardBalanceResponse = CreditCardBalance{
                creditCardBalance = creditCardBalanceResponse
                NotificationCenter.default.post(name: Notification.Name("creditCardAvailable"), object: nil)
            }else{
                presenter?.requestUserLends(Lends: {LendsResponse in
                    if LendsResponse != nil{
                        NotificationCenter.default.post(name: Notification.Name("onlyLendsAvaliable"), object: nil)
                    }else{
                        GSVCLoader.hide()
                    }
                })
            }
        })
    }
    
    func ConfigureCollectionView(){
        self.RegisterCells()
        self.BasaMainHubTableView.delegate = self
        self.BasaMainHubTableView.dataSource = self
    }
    
    func RegisterCells(){
        let bundle = Bundle(for: BASAMainHubCardsViewController.self)
        self.BasaMainHubTableView.register(UINib(nibName: "BASACardsHeaderTableViewCell", bundle: bundle), forCellReuseIdentifier: "BASACardsHeaderCell")
        self.BasaMainHubTableView.register(UINib(nibName: "BASAHomeHeaderViewComponent", bundle: bundle), forCellReuseIdentifier: "BASAHomeHeaderViewComponent")
        self.BasaMainHubTableView.register(UINib(nibName: "BASAMovementTableViewCell", bundle: bundle), forCellReuseIdentifier: "BASAMovementCell")
        self.BasaMainHubTableView.register(UINib(nibName: "BASAButtonsCell", bundle: bundle), forCellReuseIdentifier: "BASAButtonsCell")
        self.BasaMainHubTableView.register(UINib(nibName: "RequestCardCell", bundle: bundle), forCellReuseIdentifier: "RequestCardCell")
        self.BasaMainHubTableView.register(UINib(nibName: "SectionCell", bundle: bundle), forCellReuseIdentifier: "SectionCell")
        self.BasaMainHubTableView.register(UINib(nibName: "BASACreditCardInfoCell", bundle: bundle), forCellReuseIdentifier: "BASACreditCardInfoCell")
        self.BasaMainHubTableView.register(UINib(nibName: "BASALendInfoCell", bundle: bundle), forCellReuseIdentifier: "BASALendInfoCell")
        self.BasaMainHubTableView.register(UINib(nibName: "BASAMyCreditItem", bundle: bundle), forCellReuseIdentifier: "BASAMyCreditItem")
        self.BasaMainHubTableView.register(UINib(nibName: "GSNoMovementsCell", bundle: bundle), forCellReuseIdentifier: "GSNoMovementsCell")
        
    }
    
    func setTableForDebitCard(){
        viewMode = 0
        let header = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAHomeHeaderViewComponent") as! BASAHomeHeaderViewComponent
        header.cellViewController = self
        let accountData = accountBalance?.resultado.cliente?.cuentas
        
        header.debitCardlblBalance.textColor = .white
        header.debitCardlblCardNumber.text = accountData?.first?.numero?.alnovaDecrypt()
        
        header.data = accountBalance
        header.debitButton.backgroundColor = UIColor(red: 130/255, green: 0/255, blue: 255/255, alpha: 1.0)
        header.debitButton.setTitleColor(.white, for: .normal)
        if cellsArray.count == 0{
            cellsArray.append([header:headerSize])
        }else{
            removeAllExceptFirst()
        }
        
        let buttons = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAButtonsCell") as! BASAButtonsCell
        buttons.cellViewController = self
        buttons.accountBalance = self.accountBalance
        cellsArray.append([buttons:206.0])
        
        let separator = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        separator.lblTitle.text = "Movimientos"
        cellsArray.append([separator:60.0])
        
        
        if debitCardMovementsV2 != nil{
            if  debitCardMovementsV2?.resultado?.movimientos?.count ?? 0 > 0{
                var index = -1
                for item in debitCardMovementsV2!.resultado!.movimientos!{
                    index += 1
                    if  item.descripcion?.alnovaDecrypt() != ""{
                        print("fecha: \(item.fecha?.alnovaDecrypt() ?? "")")
                        let movementCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMovementCell") as! BASAMovementTableViewCell
                        
                        if item.descripcionOperacion?.contains("m") == true{
                            movementCell.lblDate.text = (item.fecha?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMM yyyy") ?? "") + " " + "MOV. PENDIENTE"
                        }else{
                            movementCell.lblDate.text = item.fecha?.dateFormatter(format: "yyyy-MM-dd", outputFormat: "dd MMM yyyy")
                        }
                        
                       
                        movementCell.tag = index
                        movementCell.lblTitle.text = item.concepto?.alnovaDecrypt()
                        
                        movementCell.lblAmount.text = item.importe?.alnovaDecrypt().removeWhiteSpaces().moneyFormatWithoutSplit()
                        movementCell.setArrow(amount: item.importe?.alnovaDecrypt() ?? "")
                        cellsArray.append([movementCell:88.0])
                    }
                }
            }else{
                let emptyMovements = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "GSNoMovementsCell")!
                cellsArray.append([emptyMovements:321])
            }
        }else{
            let emptyMovements = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "GSNoMovementsCell")!
            cellsArray.append([emptyMovements:321])
        }
        addTableComponents()
    }
    
    func setTableForCreditCard(){
        createTag(eventName: .pageView, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", origin: "credito")
        viewMode = 1
        removeAllExceptFirst()
        
        if creditCardData == nil{
            loadCreditCardInfo()
        }
        
        let digitalCardCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "RequestCardCell") as! RequestCardCell
        digitalCardCell.cellViewController = self
        digitalCardCell.cellButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        cellsArray.append([digitalCardCell:119.0])
        
        let infoCreditCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASACreditCardInfoCell") as! BASACreditCardInfoCell
        
        if creditCardData != nil{
            infoCreditCell.lblCreditLimit.text = creditCardBalance?.resultado?.montoLimiteCredito?.moneyFormat()
            infoCreditCell.lblMinimumPayment.text = creditCardBalance?.resultado?.montoPagoMinimo?.moneyFormat()
            
            //infoCreditCell.lblCutOffDate.text = creditCardBalance?.resultado?.fechaCorte?.dateFormatter(format: "dd-MM-yyyy", outputFormat: "dd MMMM")
            
            
            //let date = "Próxima fecha de pago \(creditCardBalance?.resultado?.fechaPago?.dateFormatter(format: "dd-MM-yyyy", outputFormat: "dd") ?? "Desconocida") de \(creditCardBalance?.resultado?.fechaPago?.dateFormatter(format: "dd-MM-yyyy", outputFormat: "MMMM") ?? "")"
            
            // infoCreditCell.lblNextPaymentDate.text = date
            infoCreditCell.lblPaymentToSettle.text = creditCardBalance?.resultado?.saldoDispuesto?.moneyFormat()
            infoCreditCell.lblNotInterestPayment.text = creditCardBalance?.resultado?.pagoSinInteres?.moneyFormat()
        }
        //TAMAÑO ANTERIOR 380.0
        cellsArray.append([infoCreditCell:320.0])
        
        let separator = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        separator.lblTitle.text = "Movimientos"
        cellsArray.append([separator:60.0])
        
        if creditCardMovements?.resultado?.movimientos != nil{
            for item in creditCardMovements!.resultado!.movimientos!{
                let movement = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMovementCell") as! BASAMovementTableViewCell
                movement.lblTitle.text = item.concepto
                movement.lblAmount.text = item.monto?.moneyFormat() ?? ""
                movement.lblDate.text = item.fechaHora?.dateFormatter(format: "yyyy-MM-dd HH:mm:ss", outputFormat: "dd MMM yyyy")
                movement.setArrow(amount: (item.monto?.moneyFormat() ?? ""))
                cellsArray.append([movement:88.0])
            }
        }else{
            let emptyMovements = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "GSNoMovementsCell")!
            cellsArray.append([emptyMovements:321])
        }
        
        addTableComponents()
    }
    
    func setTableForLends(){
        createTag(eventName: .pageView, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", origin: "debito")
        viewMode = 2
        removeAllExceptFirst()
        
        let infoCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASALendInfoCell") as! BASALendInfoCell
        
        infoCell.btnInfo.addTarget(self, action: #selector(showToolTip), for: .touchUpInside)
        if lendsData == nil{
            loadLends()
        }else{
            infoCell.lblNextPayment.text = "\(lendsData?.resultado?.fechaProximoPago?.dateFormatter(format: "yyyy/MM/dd", outputFormat: "dd") ?? "") de \(lendsData?.resultado?.fechaProximoPago?.dateFormatter(format: "yyyy/MM/dd", outputFormat: "MMMM") ?? "")"
            infoCell.lblPaymentWithDiscount.text = lendsData?.resultado?.pagoPuntual?.moneyFormat()
            infoCell.lblSuggestedPayment.text = String(lendsData?.resultado?.pagoSugerido ?? 0).moneyFormat()
            infoCell.lblFixedPayment.text = lendsData?.resultado?.pagoNormal?.moneyFormat()
            infoCell.lblPaymentDay.text = lendsData?.resultado?.fechaProximoPago?.dateFormatter(format: "yyyy/MM/dd", outputFormat: "EEEE")
        }
        cellsArray.append([infoCell:300.0])
        
        let separator = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        separator.lblTitle.text = "Mis créditos"
        cellsArray.append([separator:60.0])
        
        if lendsData?.resultado?.productos != nil{
            for item in lendsData!.resultado!.productos!{
                if item.id != 0{
                    let creditItem = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMyCreditItem") as! BASAMyCreditItem
                    
                    creditItem.lblAmount.text = item.pagoLiquidar?.moneyFormat()
                    
                    creditItem.setTitle(id: item.id ?? -1)
                    cellsArray.append([creditItem:180.0])
                }
            }
        }
        
        addTableComponents()
    }
    
    func removeAllExceptFirst(){
        if cellsArray.count > 0{
            let count = cellsArray.count
            for _ in 1..<count{
                cellsArray.removeLast()
            }
            
            var cellsToRemove: [IndexPath] = []
            
            for n in 1..<BasaMainHubTableView.numberOfRows(inSection: 0){
                cellsToRemove.append([0,n])
            }
            
            BasaMainHubTableView.deleteRows(at: cellsToRemove, with: .right)
        }
    }
    
    func addTableComponents(){
        var cellsToAdd: [IndexPath] = []
        for n in 1..<cellsArray.count{
            cellsToAdd.append([0,n])
        }
        BasaMainHubTableView.insertRows(at: cellsToAdd, with: .left)
    }
    
    func optionalAction() {
        print("OK")
    }
    
    @objc func activityObserve(){
        startTime = Date()
        time = 300.0
    }
    
    @objc func updateHeaderSize(sender: Notification){
        if cellsArray.count > 0{
            let cell = (cellsArray[0].first?.key)!
            UIView.animate(withDuration: 0.5) { [self] in
                BasaMainHubTableView.beginUpdates()
                cellsArray[0].updateValue(380.0, forKey: cell)
                BasaMainHubTableView.endUpdates()
            }
            refreshControl.endRefreshing()
            setUpRefreshControl()
        }
    }
    
    @objc func SwitchColors(notification: Notification){
        if notification.object != nil{
            let colorType = notification.object as! cardType
            switch colorType {
            case .credit:
                setTableForCreditCard()
            case .debit:
                setTableForDebitCard()
            case .lending:
                setTableForLends()
            }
        }
    }
    
    @objc func showToolTip(){
        GSVTTooltipRouter.createModule(target: self, title: "Pago sugerido", message: "Al realizar este pago, aprovechas los beneficios del pago puntual y adelantas una semana para terminar de pagar antes.")
    }
    
    @objc func showAlert(){
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "dashboard", screenName: "movimientos", type: "click", element: "tarjeta_digital", origin: "credito")
        presentBottomAlertFullData(status: .caution, message: "En este momento no cuentas con tarjeta digital", attributedString: .none, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        switch viewMode{
        case 0:
            loadDebitBalance()
        case 1:
            loadCreditCardInfo()
        case 2:
            loadLends()
        default:
            print("Default case")
        }
    }
}

extension BASAMainHubCardsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  cellsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellsArray[indexPath.row].first!.key
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellsArray[indexPath.row].first!.value
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = BasaMainHubTableView.cellForRow(at: indexPath)
        if cell is BASAMovementTableViewCell{
            if debitCardMovementsV2?.resultado?.movimientos?.count ?? 0 > 0{
                let item = cell as! BASAMovementTableViewCell
                let data = debitCardMovementsV2?.resultado?.movimientos![item.tag]
                let view = GSSAMovementPreviewRouter.createModule(index: item.tag, item: data!, array: debitCardMovementsV2!)
                //self.navigationController?.pushViewController(view, animated: true)
                view.modalPresentationStyle = .overCurrentContext
                self.present(view, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        activityObserve()
    }
}
