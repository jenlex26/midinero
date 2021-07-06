//
//  BASACardCell.swift
//  TEST3
//
//  Created by Desarrollo on 21/05/21.
//

import UIKit

class BASACardCell: UICollectionViewCell {
    
    @IBOutlet weak var CardBackgroundView: UIView!
    @IBOutlet weak var lblCardNumber     : UILabel!
    @IBOutlet weak var lblExpDate        : UILabel!
    @IBOutlet weak var lblBalance        : UILabel!
    @IBOutlet weak var lblVigencia       : UILabel!
    @IBOutlet weak var lblOweMoney       : UILabel!
    @IBOutlet weak var btnConfig         : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnConfig.layer.masksToBounds = true
        btnConfig.layer.cornerRadius = btnConfig.frame.width/2
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCards), name: NSNotification.Name(rawValue: "reloadHeaderData"), object: nil)
    }
    
    @objc func reloadCards(notification: Notification){
        if notification.object != nil{
            let data = notification.object as? BalanceResponse
            //self.lblCardNumber.text = data?.resultado.cliente?.cuentas?.first?.numero?.tnuoccaFormat
        }
    }
}
