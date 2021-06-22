//
//  BASACardControl.swift
//  GSSAFront
//
//  Created by Desarrollo on 14/06/21.
//

import UIKit
import GSSAVisualComponents

class BASACardControl: UITableViewCell {
    
    @IBOutlet weak var cardControlView: UIView!
    @IBOutlet weak var turnOfSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.GSVCBase300
        self.cardControlView.layer.shadowColor = UIColor.lightGray.cgColor
        self.cardControlView.layer.shadowRadius = 6
        self.cardControlView.layer.shadowOpacity = 0.1
        self.cardControlView.layer.masksToBounds = true
    }
}
