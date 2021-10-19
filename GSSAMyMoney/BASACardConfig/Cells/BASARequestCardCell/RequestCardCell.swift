//
//  RequestCardCell.swift
//  GSSAFront
//
//  Created by Andoni Suarez on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class RequestCardCell: UITableViewCell{
  
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var lblTitle  : GSVCLabel! 
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var imgIcon  : UIImageView!
    @IBOutlet weak var lblTracking: GSVCLabel!
    
    var cellViewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        buttonView.layer.cornerRadius = 10
        buttonView.layer.masksToBounds = true
        imgIcon.image = UIImage.chevronRight()
    }
        
}
