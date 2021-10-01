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
import FirebaseRemoteConfig
//import GSSAAceptaPago

class BASAButtonsCell: UITableViewCell, GSVTDigitalSignDelegate {
    
    @IBOutlet weak var cellButtonView       : UIView!
    @IBOutlet weak var separatorView        : UIView!
    @IBOutlet weak var cellContentView      : UIView!
    @IBOutlet weak var cashWithdrawalView   : UIView!
    @IBOutlet weak var sendWithQRView       : UIView!
    @IBOutlet weak var openDigitalCardButton: UIButton!
    @IBOutlet weak var chevronIcon          : UIImageView!
    @IBOutlet weak var stack: UIStackView!
    
    var cellViewController: UIViewController!
    var accountBalance: BalanceResponse?
    var sendToFund = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        separatorView.backgroundColor = UIColor.GSVCBase300()
        cellButtonView.layer.cornerRadius = 10
        cellButtonView.layer.masksToBounds = true
        
        if #available(iOS 13.0, *){()}else{
            chevronIcon.image = UIImage.chevronRight()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notification:)), name: NSNotification.Name(rawValue: "reloadHeaderData"), object: nil)
        
        if let podcastsStr = RemoteConfig.remoteConfig().remoteString(forKey: "MOB_SA_QRStore"){
            if podcastsStr == "false"{
                sendWithQRView.isHidden = false
                cashWithdrawalView.isHidden = true
            }else{
                sendWithQRView.isHidden = true
                cashWithdrawalView.isHidden = false
            }
        }
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
            sendToFund = true
            tagFundAccount()
            let verification = GSVTDigitalSignViewController(delegate: self)
            verification.bShouldWaitForNewToken = false
            verification.modalPresentationStyle = .fullScreen
            if cellViewController != nil{
                cellViewController.present(verification, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func cashWithdrawal(sender: Any){
        sendToFund = false
        let verification = GSVTDigitalSignViewController(delegate: self)
        verification.bShouldWaitForNewToken = false
        verification.modalPresentationStyle = .fullScreen
        if cellViewController != nil{
            createTag(eventName: .pageView, section: "mi_dinero", flow: "fondear_cuenta", screenName: "clave_de_seguridad", origin: "debito")
            cellViewController.present(verification, animated: true, completion: nil)
        }
    }
    
    @IBAction func openDigitalCard(sender: Any){
        tagShowDebitDigitalCard()
        let data = accountBalance?.resultado.cliente?.cuentas?.first?.saldoDisponible?.moneyFormat() ?? ""
        cellViewController.navigationController?.pushViewController(BASADigitalCardRouter.createModule(userBalance: data), animated: true)
    }
    
    @IBAction func aceptaPago(sender: Any){
        if cellViewController != nil{
          //  let view = GSSAAceptaPagoCalculatorRouter.createModule()
         //   cellViewController.navigationController?.pushViewController(view, animated: true)
        }
    }
    
    func forgotDigitalSign(_ forgotSecurityCodeViewController: UIViewController?) {
        createTag(eventName: .UIInteraction, section: "mi_dinero", flow: "fondear_cuenta", screenName: "clave_de_seguridad", type: "click", element: "olvide_clave_seguridad", origin: "debito")
    }
    
    func verification(_ success: Bool, withSecurityCode securityCode: String?, andUsingBiometric usingBiometric: Bool) {
        if cellViewController != nil{
            if sendToFund == true{
                if RemoteConfig.remoteConfig().remoteString(forKey: "iOS_SA_CashInWindow") == "true"{
                    GSINAdminNavigator.shared.startFlow(forAction: "GSIFTr_MenuReload",
                                                        navigateDelegate: self)
                }else{
                    let view = GSSALinkDePagoRouter.createModuleWithNavigation()
                    cellViewController.navigationController?.pushViewController(view, animated: true)
                }
            }else{
                GSINAdminNavigator.shared.startFlow(forAction: "GSIFPqr_CashPickup",
                                                    navigateDelegate: self)
            }
        }
    }
}

extension BASAButtonsCell: GSINNavigateDelegate{
    func willFinishFlow(withInfo info: [String : Any]?) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "externalFlowFinished"), object: nil, userInfo: nil))
    }
    
    func didFailToEnterFlow(error: NSError) {()}
    
}
