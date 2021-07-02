//
//  BASACreditCardInfoCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit

class BASACreditCardInfoCell: UITableViewCell {

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
