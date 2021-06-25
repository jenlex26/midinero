//
//  BASAMainHubCardsViewController.swift
//  GSSAFront
//
//  Created BranchbitG on 15/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents

class BASAMainHubCardsViewController: UIViewController, BASAMainHubCardsViewProtocol, GSVCBottomAlertHandler {
    var bottomAlert: GSVCBottomAlert?
    var presenter: BASAMainHubCardsPresenterProtocol?
    
    @IBOutlet weak var BasaMainHubTableView:UITableView!
    
    var cellsArray: Array<[UITableViewCell:CGFloat]> = []
    
    var accountBalance: BalanceResponse?
    var debitCardMovements: DebitCardTransaction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ConfigureCollectionView()
        self.BasaMainHubTableView.alwaysBounceVertical = false
        NotificationCenter.default.addObserver(self, selector: #selector(SwitchColors(notification:)), name: NSNotification.Name(rawValue: "HomeHeaderViewChange"), object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        loadDebitBalance()
        self.setTableForDebitCard()
    }
    
    func loadDebitBalance(){
        GSVCLoader.show(type: .native)
        presenter?.requestBalance(Account: "01274624231334908261", Balance: { Balance in
            if let NewBalance = Balance{
                DispatchQueue.main.async {
                    self.accountBalance = NewBalance
                    NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "reloadHeaderData"), object: NewBalance, userInfo: nil))
                    self.loadDebitMovements()
                }
            }else{
                GSVCLoader.hide()
                self.presentBottomAlertFullData(status: .error, message: "Ocurrió un error desconocido, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }
        })
    }
    
    func loadDebitMovements(){
        self.presenter?.requestDebitCardMovements(Body: MovimientosBody(transaccion: MovementsBodyData(numeroCuenta: "01274624231334908261", fechaInicial: "20/09/2018", fechaFinal: "23/11/2018")), Movements: { [self] Movements in
            GSVCLoader.hide()
            if Movements != nil{
                debitCardMovements = Movements
                setTableForDebitCard()
            }else{
                self.presentBottomAlertFullData(status: .error, message: "Ocurrió un error al cargar tus movimientos, intenta más tarde", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: true, optionalButtonText:nil)
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
        let header = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAHomeHeaderViewComponent") as! BASAHomeHeaderViewComponent
        header.cellViewController = self
        let accountData = accountBalance?.resultado.cliente?.cuentas
        header.debitCardlblBalance.text = accountData?.first?.saldoDisponible
        header.debitCardlblCardNumber.text = accountData?.first?.numero
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
        cellsArray.append([buttons:200.0])
        
        let separator = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        separator.lblTitle.text = "Movimientos"
        cellsArray.append([separator:60.0])
        
        if debitCardMovements != nil{
            for item in debitCardMovements!.resultado.movimientos{
                let movementCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMovementCell") as! BASAMovementTableViewCell
                movementCell.lblDate.text = item.fechaOperacion
                movementCell.lblTitle.text = item.descripcion
                movementCell.lblAmount.text = item.importe
                cellsArray.append([movementCell:88.0])
            }
        }else{
            let emptyMovements = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "GSNoMovementsCell")!
            cellsArray.append([emptyMovements:321])
        }
        
        addTableComponents()
    }
    
    func setTableForCreditCard(){
        removeAllExceptFirst()
        
        let digitalCardCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "RequestCardCell")!
        cellsArray.append([digitalCardCell:119.0])
        
        let infoCreditCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASACreditCardInfoCell")!
        cellsArray.append([infoCreditCell:380.0])
        
        
        let separator = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        separator.lblTitle.text = "Movimientos"
        cellsArray.append([separator:60.0])
        
        let movement = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMovementCell") as! BASAMovementTableViewCell
        movement.lblTitle.text = "Compra en Oxxo"
        cellsArray.append([movement:88.0])
        
        let movement2 = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMovementCell") as! BASAMovementTableViewCell
        movement2.lblTitle.text = "Compra el Walmart"
        cellsArray.append([movement2:88.0])
        
        addTableComponents()
    }
    
    func setTableForLends(){
        removeAllExceptFirst()
        let infoCell = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASALendInfoCell")!
        cellsArray.append([infoCell:300.0])
        
        let separator = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "SectionCell") as! SectionCell
        separator.lblTitle.text = "Mis créditos"
        cellsArray.append([separator:60.0])
        
        
        let creditExample1 = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMyCreditItem")!
        cellsArray.append([creditExample1:180.0])
        
        let creditExample2 = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMyCreditItem") as! BASAMyCreditItem
        creditExample2.lblAmount.text = "$6,000.00"
        creditExample2.lblTitle.text = "Crédito Elektra"
        cellsArray.append([creditExample2:180.0])
        
        let creditExample3 = BasaMainHubTableView.dequeueReusableCell(withIdentifier: "BASAMyCreditItem") as! BASAMyCreditItem
        creditExample3.lblAmount.text = "$1,000.00"
        creditExample3.lblTitle.text = "Otros créditos"
        cellsArray.append([creditExample3:180.0])
        
        //BasaMainHubTableView.reloadData()
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
                if #available(iOS 13.0, *) {
                    UIApplication.shared.statusBarStyle = .lightContent
                } 
                setTableForCreditCard()
            case .debit:
                setTableForDebitCard()
                if #available(iOS 13.0, *) {
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            case .lending:
                setTableForLends()
                if #available(iOS 13.0, *) {
                    UIApplication.shared.statusBarStyle = .lightContent
                }
            }
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
}

extension UIButton {
    func alignVertical(spacing: CGFloat = 6.0) {
        guard let imageSize = self.imageView?.image?.size,
              let text = self.titleLabel?.text,
              let font = self.titleLabel?.font
        else { return }
        self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0.0)
        let labelString = NSString(string: text)
        let titleSize = labelString.size(withAttributes: [kCTFontAttributeName as NSAttributedString.Key: font])
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0;
        self.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)
    }
}

extension UIView{
    func createCurve(curvedPercent:CGFloat) ->UIBezierPath{
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        arrowPath.addLine(to: CGPoint(x:self.bounds.size.width, y:0))
        arrowPath.addLine(to: CGPoint(x:self.bounds.size.width, y:self.bounds.size.height - (self.bounds.size.height*curvedPercent)))
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:self.bounds.size.height - (self.bounds.size.height*curvedPercent)), controlPoint: CGPoint(x:self.bounds.size.width/2, y:self.bounds.size.height))
        arrowPath.addLine(to: CGPoint(x:0, y:0))
        arrowPath.close()
        
        return arrowPath
    }
    
    func applyCurveToView(curvedPercent:CGFloat) {
        guard curvedPercent <= 1 && curvedPercent >= 0 else{
            return
        }
        
        let shapeLayer = CAShapeLayer(layer: self.layer)
        shapeLayer.path = self.createCurve(curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = self.bounds
        shapeLayer.masksToBounds = true
        self.layer.mask = shapeLayer
    }
}
