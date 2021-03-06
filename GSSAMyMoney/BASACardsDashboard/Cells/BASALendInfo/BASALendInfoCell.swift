//
//  BASALendInfoCell.swift
//  GSSAFront
//
//  Created by Andoni Suarez on 17/06/21.
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates

class BASALendInfoCell: UITableViewCell {
    
    @IBOutlet weak var separatorView           : UIView!
    @IBOutlet weak var btnInfo                 : UIButton!
    @IBOutlet weak var lblPaymentDay           : GSVCLabel!
    @IBOutlet weak var lblPaymentWithDiscount  : GSVCLabel!
    @IBOutlet weak var lblFixedPayment         : GSVCLabel!
    @IBOutlet weak var lblSuggestedPayment     : GSVCLabel!
    @IBOutlet weak var lblNextPayment          : GSVCLabel!
    @IBOutlet weak var lblDigitalPayment    : GSVCLabel! 
    
    var cellViewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        separatorView.backgroundColor = UIColor.GSVCBase300()
    }
}
