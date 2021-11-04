//
//  GSSAOfflineControlCell.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez  on 02/11/21.
//

import UIKit
import GSSAInterceptor

class GSSAOfflineControlCell: UITableViewCell, GSINNavigateDelegate {
 
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func didFailToEnterFlow(error: NSError) {()}
    
    @IBAction func withdraw(_ sender: Any){
        GSINAdminNavigator.shared.startFlow(forAction: "BASAWAWithdraw",
                                                            navigateDelegate: self)
    }
    
    @IBAction func fundAccount(_ sender: Any){
        GSINAdminNavigator.shared.startFlow(forAction: "BASAWAFund",
                                                            navigateDelegate: self)
    }
    
    @IBAction func deleteWallet(_ sender: Any){
    
    }
}
