//
//  GSNoMovementsCell.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 24/06/21.
//

import UIKit

class GSNoMovementsCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
