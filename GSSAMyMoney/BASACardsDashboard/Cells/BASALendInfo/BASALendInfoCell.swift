//
//  BASALendInfoCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates

class BASALendInfoCell: UITableViewCell {
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var btnInfo      : UIButton!
    
    var cellViewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        separatorView.backgroundColor = UIColor.GSVCBase300()
    }
    
    @IBAction func showMessage(_ sender: Any){
     
    }
}
