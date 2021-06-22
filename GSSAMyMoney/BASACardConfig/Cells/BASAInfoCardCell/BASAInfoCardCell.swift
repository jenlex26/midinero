//
//  BASAInfoCardCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class BASAInfoCardCell: UITableViewCell {

    @IBOutlet weak var lblText: GSVCLabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
}
