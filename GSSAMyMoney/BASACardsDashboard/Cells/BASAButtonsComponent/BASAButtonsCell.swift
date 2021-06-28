//
//  BASAButtonsCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit

class BASAButtonsCell: UITableViewCell {
    
    @IBOutlet weak var cellButtonView: UIView!
    @IBOutlet weak var openDigitalCardButton: UIButton!
    @IBOutlet weak var stack: UIStackView!

    var cellViewController: UIViewController!
    var accountBalance: BalanceResponse?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.GSVCBase200
        // corner radius
        cellButtonView.layer.cornerRadius = 10
        cellButtonView.layer.masksToBounds = true
        // border
        cellButtonView.layer.borderWidth = 0.2
        if #available(iOS 13.0, *) {
            cellButtonView.layer.borderColor = UIColor.label.cgColor
        }

        // shadow
        stack.layer.shadowColor = UIColor.black.cgColor
        stack.layer.shadowOffset = CGSize(width: 3, height: 3)
        stack.layer.shadowOpacity = 0.7
        stack.layer.shadowRadius = 4.0
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData(notification:)), name: NSNotification.Name(rawValue: "reloadHeaderData"), object: nil)
    }
    
    @objc func updateData(notification: Notification){
        if notification.object != nil{
            accountBalance = (notification.object as! BalanceResponse)
        }
    }
    
    
    @IBAction func openDigitalCard(sender: Any){
        if cellViewController != nil{
            let data = accountBalance?.resultado.cliente?.cuentas?.first?.saldoDisponible?.alnovaDecrypt().moneyFormat() ?? ""
            cellViewController.navigationController?.pushViewController(BASADigitalCardRouter.createModule(userBalance: data), animated: true)
        }
    }
}
