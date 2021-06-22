//
//  RequestCardCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class RequestCardCell: UITableViewCell {

    @IBOutlet weak var buttonView: GSVCView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.GSVCBase300
        self.selectionStyle = .none
        self.buttonView.layer.shadowColor = UIColor.lightGray.cgColor
        self.buttonView.layer.shadowRadius = 6
        self.buttonView.layer.shadowOpacity = 0.1
    }
}
