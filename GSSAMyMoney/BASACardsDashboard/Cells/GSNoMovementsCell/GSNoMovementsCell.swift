//
//  GSNoMovementsCell.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 24/06/21.
//

import UIKit

class GSNoMovementsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
