//
//  BASAButtonsCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit
import GSSAInterceptor
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSAFirebaseManager

class BASAButtonsCell: UITableViewCell, GSVTDigitalSignDelegate {
    
    @IBOutlet weak var cellButtonView: UIView!
    @IBOutlet weak var separatorView : UIView!
    @IBOutlet weak var cellContentView : UIView!
    @IBOutlet weak var openDigitalCardButton: UIButton!
    @IBOutlet weak var stack: UIStackView!
    
    var cellViewController: UIViewController!
    var accountBalance: BalanceResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        separatorView.backgroundColor = UIColor.GSVCBase300()
        cellButtonView.layer.cornerRadius = 10
        cellButtonView.layer.masksToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notification:)), name: NSNotification.Name(rawValue: "reloadHeaderData"), object: nil)
    }
    
    @objc func updateData(notification: Notification){
        if notification.object != nil{
            accountBalance = (notification.object as! BalanceResponse)
        }
    }
    
    @IBAction func sendAndPay(sender: Any){
        if cellViewController != nil{
            tagSendMoneyFlow()
            GSINAdminNavigator.shared.startFlow(forAction: "GSIFTr",
                                                navigateDelegate: self)
        }
    }
    
    @IBAction func payWithQR(sender: Any){
        if cellViewController != nil{
            tagReceiveAndPayFlow()
            GSINAdminNavigator.shared.startFlow(forAction: "GSIFCqr",
                                                navigateDelegate: self)
        }
    }
    
    @IBAction func tiempoAire(sender: Any){
        if cellViewController != nil{
            tagPhoneMinutesFlow()
            GSINAdminNavigator.shared.startFlow(forAction: "GSIFAt",
                                                navigateDelegate: self)
        }
    }
    
    @IBAction func foundAccoun(sender: Any){
        if cellViewController != nil{
            tagFundAccount()
            let verification = GSVTDigitalSignViewController(delegate: self)
            verification.bShouldWaitForNewToken = false
            verification.modalPresentationStyle = .fullScreen
            if cellViewController != nil{
                cellViewController.present(verification, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func openDigitalCard(sender: Any){
        tagShowDebitDigitalCard()
        let data = accountBalance?.resultado.cliente?.cuentas?.first?.saldoDisponible?.moneyFormat() ?? ""
        cellViewController.navigationController?.pushViewController(BASADigitalCardRouter.createModule(userBalance: data), animated: true)
    }
    
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) {
        print("NIP INCORRECTO")
    }
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        if cellViewController != nil{
            let view = GSSALinkDePagoRouter.createModuleWithNavigation()
            cellViewController.navigationController?.pushViewController(view, animated: true)
        }
    }
}

extension BASAButtonsCell: GSINNavigateDelegate{
    func willFinishFlow(withInfo info: [String : Any]?) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "externalFlowFinished"), object: nil, userInfo: nil))
    }
    
    func didFailToEnterFlow(error: NSError) {
        print(error)
    }
    
}
