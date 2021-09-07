//
//  BASACardControl.swift
//  GSSAFront
//
//  Created by Andoni Suarez on 14/06/21.
//

import UIKit
import GSSAVisualComponents

class BASACardControl: UITableViewCell {
    
    @IBOutlet weak var cardControlView  : UIView!
    @IBOutlet weak var turnOfSwitch     : UISwitch!
    @IBOutlet weak var reportCardView   : UIView!
    @IBOutlet weak var turnOffCard      : UIView!
    @IBOutlet weak var nipCardView      : UIView!
    @IBOutlet weak var btnCheckNIP      : UIButton!
    @IBOutlet weak var lblCheckNIP      : GSVCLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.backgroundColor = UIColor.GSVCBase200
        self.cardControlView.layer.shadowColor = UIColor.lightGray.cgColor
        self.cardControlView.layer.shadowRadius = 6
        self.cardControlView.layer.shadowOpacity = 0.1
        self.cardControlView.layer.masksToBounds = true
    }
}
