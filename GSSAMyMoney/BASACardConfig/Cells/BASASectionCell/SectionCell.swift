//
//  SectionCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class SectionCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: GSVCLabel!
    @IBOutlet weak var lblSubTitle: GSVCLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.isUserInteractionEnabled = false
    }
}
