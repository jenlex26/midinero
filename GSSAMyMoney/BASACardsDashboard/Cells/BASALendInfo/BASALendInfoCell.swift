//
//  BASALendInfoCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit

class BASALendInfoCell: UITableViewCell {
    
    @IBOutlet weak var separatorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        separatorView.backgroundColor = UIColor.GSVCBase300()
    }
}
