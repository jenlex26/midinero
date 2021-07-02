//
//  ConfigItemCell.swift
//  GSSAFront
//
//  Created by Desarrollo on 13/06/21.
//

import UIKit
import GSSAVisualComponents

class ConfigItemCell: UITableViewCell {

    @IBOutlet weak var lblTitle: GSVCLabel!
    @IBOutlet weak var lblSubtitle: GSVCLabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle  = .none
        imgView.tintColor = UIColor.GSVCSecundary100
    }
    
    func configureCell(title: String, subtitle: String? = nil, image: UIImage? = nil){
        self.lblTitle.text = title
        
        if image != nil{
            self.imgView.image = image
        }else{
            self.imgView.isHidden = true
        }
        
        if subtitle != nil{
            self.lblSubtitle.text = subtitle
        }else{
            self.lblSubtitle.isHidden = true
        }
    }
}
