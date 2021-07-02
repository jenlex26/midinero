//
//  BASAButtonsCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit
import GSSAInterceptor

class BASAButtonsCell: UITableViewCell {
    
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
//        self.backgroundColor = UIColor.GSVCBase300()
//        cellContentView.backgroundColor = UIColor.GSVCBase300()
        separatorView.backgroundColor = UIColor.GSVCBase300()
        // corner radius
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
            GSINAdminNavigator.shared.startFlow(forAction: "GSIFTr_SendCel",
                                                navigateDelegate: self)
        }
    }
    
    @IBAction func payWithQR(sender: Any){
        if cellViewController != nil{
            GSINAdminNavigator.shared.startFlow(forAction: "GSIFCqr",
                                                navigateDelegate: self)
        }
    }
    
    @IBAction func tiempoAire(sender: Any){
        if cellViewController != nil{
            GSINAdminNavigator.shared.startFlow(forAction: "GSIFTr_RecCel",
                                                navigateDelegate: self)
        }
    }
    
    @IBAction func openDigitalCard(sender: Any){
        if cellViewController != nil{
            let data = accountBalance?.resultado.cliente?.cuentas?.first?.saldoDisponible?.alnovaDecrypt().moneyFormat() ?? ""
            cellViewController.navigationController?.pushViewController(BASADigitalCardRouter.createModule(userBalance: data), animated: true)
        }
    }
}

extension BASAButtonsCell: GSINNavigateDelegate{
    func willFinishFlow(withInfo info: [String : Any]?) {
        
    }
    
    func didFailToEnterFlow(error: NSError) {
        
    }
    
}
