//
//  BASASwitchItemCell.swift
//  GSSAFront
//
//  Created by Andoni Suarez on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class BASASwitchItemCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: GSVCLabel!
    @IBOutlet weak var lblSubTitle: GSVCLabel!
    @IBOutlet weak var swtch: UISwitch!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        swtch.backgroundColor = .clear
    }
    
    func configureCell(title: String, subtitle: String?){
        lblTitle.text = title
        if subtitle != nil{
            lblSubTitle.text = subtitle
        }else{
            lblSubTitle.isHidden = true
        }
    }
}
