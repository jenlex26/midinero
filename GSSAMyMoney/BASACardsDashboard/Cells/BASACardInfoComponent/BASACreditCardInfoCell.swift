//
//  BASACreditCardInfoCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit
import GSSAVisualComponents

class BASACreditCardInfoCell: UITableViewCell {
    
    @IBOutlet weak var lblCutOffDate        : GSVCLabel!
    @IBOutlet weak var lblMinimumPayment    : GSVCLabel!
    @IBOutlet weak var lblPaymentToSettle   : GSVCLabel!
    @IBOutlet weak var lblCreditLimit       : GSVCLabel!
    @IBOutlet weak var lblNotInterestPayment: GSVCLabel!
    @IBOutlet weak var lblNextPaymentDate   : GSVCLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.GSVCBase300()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
