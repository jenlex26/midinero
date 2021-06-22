//
//  BASAMovementTableViewCell.swift
//  BASAMyPaymentsScreens
//
//  Created by BranchbitG on 18/05/21.
//

import UIKit
import GSSAVisualComponents

class BASAMovementTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: GSVCLabel!
    @IBOutlet weak var lblAmount: GSVCLabel!
    @IBOutlet weak var lblDate: GSVCLabel!
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
