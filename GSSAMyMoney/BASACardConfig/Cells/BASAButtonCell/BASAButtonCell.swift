//
//  BASAButtonCell.swift
//  GSSAFront
//
//  Created by Andoni Suarez on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class BASAButtonCell: UITableViewCell {
    
    @IBOutlet weak var btnNext: GSVCButton!

    let color = UIColor.GSVCPrincipal100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
}
