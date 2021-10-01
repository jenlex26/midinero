//
//  BeneficiaryButtonCell.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 30/06/21.
//

import UIKit
import GSSAVisualComponents

class BeneficiaryButtonCell: UITableViewCell {
    
    @IBOutlet weak var button: GSVCButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        if #available(iOS 13.0, *){()}else{
            button.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
            button.imageView?.contentMode = .scaleAspectFit
        }
        button.setImage(UIImage.personIcon(), for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
