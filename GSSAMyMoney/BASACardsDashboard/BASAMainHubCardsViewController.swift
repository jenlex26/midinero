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
    var lendsData: LendsResponse?
    var creditCardData: CreditCardResponse?
    var creditCardBalance: CreditCardBalanceResponse?
    var creditCardMovements: CreditCardMovementsResponse?
    var accountNumber: [String:String]?
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inicializeView()
        let verification = GSVTDigitalSignViewController(delegate: self)
        verification.modalPresentationStyle = .fullScreen
        self.present(verification, animated: true, completion: nil)
    }
    
    func inicializeView(){
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        BasaMainHubTableView.addSubview(refreshControl)
        ConfigureCollectionView()
        self.BasaMainHubTableView.alwaysBounceVertical = false
        NotificationCenter.default.addObserver(self, selector: #selector(SwitchColors(notification:)), name: NSNotification.Name(rawValue: "HomeHeaderViewChange"), object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setTableForDebitCard()
    }
    
    func loadDebitBalance(){
        GSVCLoader.show(type: .native)
        presenter?.requestBalance(Account: [accountNumber?.first?.key.encryptAlnova() ?? (GSSISessionInfo.sharedInstance.gsUser.mainAccount?.encryptAlnova() ?? ""): accountNumber?.first?.value ?? (GSSISessionInfo.sharedInstance.gsUser.SICU?.encryptAlnova() ?? "")], Balance: { Balance in
            if let NewBalance = Balance{
                DispatchQueue.main.async {
                    self.accountBalance = NewBalance
                    UserDefaults.standard.setValue(NewBalance.resultado.cliente?.cuentas?.first?.clabe?.alnovaDecrypt().tnuoccaFormat, forKey: "DebitCardCLABE")
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadHeaderData"), object: NewBalance, userInfo: nil))
                    self.loadDebitMovements()
                }
            }else{
                GSVCLoader.hide()
                self.presentBottomAlertFullData(status: .error, message: "No podemos cargar tu saldo en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadDebitMovements(){
        self.presenter?.requestDebitCardMovements(Body: MovimientosBody(transaccion: MovementsBodyData(numeroCuenta: accountNumber?.first?.key ?? (GSSISessionInfo.sharedInstance.gsUser.mainAccount?.encryptAlnova()), fechaInicial: "01/01/0001", fechaFinal: "01/01/0001")), Movements: { [self] Movements in
            GSVCLoader.hide()
            if Movements != nil{
                debitCardMovements = Movements
                setTableForDebitCard()
            }else{
                self.presentBottomAlertFullData(status: .error, message: "No podemos cargar tus movimientos en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        })
    }
    
    func loadLends(){
        GSVCLoader.show(type: .native)
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
        let numberCard = "4589090200115840"
        GSVCLoader.show(type: .native)
        presenter?.requestCreditCardData(Body: CreditCardBody.init(transaccion: CreditCardTransaccion.init(numeroCuenta: "", numeroTarjeta: numberCard, numeroContrato: "")), CreditCardData: { [self] CreditCardData in
            if let CreditCard = CreditCardData{
                creditCardData = CreditCard
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadCreditCardData"), object: CreditCard, userInfo: nil))
                loadCreditCardBalance()
            }else{
                GSVCLoader.hide()
                self.presentBottomAlertFullData(status: .error, message: "No podemos obtener los datos de la tarjeta de crédito en este momento, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func loadCreditCardBalance(){
        presenter?.requestCreditCardBalance(Body: CreditCardBalanceBody.init(transaccion: CreditCardBalanceTransaccion.init(numeroTarjeta: "5165830500011341")), CreditCardBalance: { [self] CreditCardBalance in
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
        header.debitCardlblBalance.text = UserDefaults.standard.value(forKey: "debitAccountBalance") as? String
        
        header.debitCardlblCardNumber.text = accountData?.first?.numero?.alnovaDecrypt()
        
        header.data = accountBalance
        header.debitButton.backgroundColor = UIColor(red: 130/255, green: 0/255, blue: 255/255, alpha: 1.0)
        header.debitButton.setTitleColor(.white, for: .normal)
        if cellsArray.count == 0{
            cellsArray.append([header:380.0])
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
        
        
        if debitCardMovements != nil{
            for item in debitCardMovements!.resultado.movimientos{
                if  item.descripcion?.alnovaDecrypt() != ""{
                    let movementCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMovementCell") as! BASAMovementTableViewCell
                    movementCell.lblDate.text = item.fechaOperacion?.dateFormatter(format: "yyyy/MM/dd", outputFormat: "dd MMM yyyy")
                    movementCell.lblTitle.text = item.descripcion?.alnovaDecrypt()
                    movementCell.lblAmount.text = item.importe?.alnovaDecrypt().moneyFormat()
                    movementCell.setArrow(amount: item.importe?.alnovaDecrypt() ?? "")
                    cellsArray.append([movementCell:88.0])
                }
            }
        }else{
            let emptyMovements = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "GSNoMovementsCell")!
            cellsArray.append([emptyMovements:321])
        }
        
        addTableComponents()
    }
    
    func setTableForCreditCard(){
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
        
        cellsArray.append([infoCreditCell:380.0])
        
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
            let item = cell as! BASAMovementTableViewCell
            let data = DebitCardTransactionItem.init(importe: item.lblAmount.text, saldo: "", descripcion: item.lblTitle.text, fechaOperacion: item.lblDate.text, numeroMovimiento: "", codigoDivisa: "")
            let view = GSSAMovementPreviewRouter.createModule(item: data)
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}

extension BASAMainHubCardsViewController: GSVTDigitalSignDelegate{
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) {}
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        loadDebitBalance()
    }
    
    func cancelDigitalSing(_ isUserBlocked: Bool) {
        self.dismiss(animated: true, completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }
}
