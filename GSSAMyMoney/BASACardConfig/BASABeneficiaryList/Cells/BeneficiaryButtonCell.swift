//
//  BeneficiaryButtonCell.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 30/06/21.
//

import UIKit
import GSSAVisualComponents

class BeneficiaryButtonCell: UITableViewCell {
    
    @IBOutlet weak var button: GSVCButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        button.setImage(UIImage.personIcon(), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
