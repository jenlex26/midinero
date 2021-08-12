//
//  BASAScanCodeButtonsViewController.swift
//  GSSAFront
//
//  Created by Benigno Marin Mendoza on 07/06/21.
//

import UIKit
import GSSAVisualTemplates
import GSSAVisualComponents

protocol BASAScanCodeButtonsViewControllerDelegate {
    func onClickGenerateBtn()
    func showAndHidePanel(_ sender: GSVCButton)
}

class BASAScanCodeButtonsViewController: GSVTMasterViewController {
    private let xibName: String = "BASAScanCodeButtonsViewController"
    var delegate: BASAScanCodeButtonsViewControllerDelegate?
    
    @IBOutlet private weak var generaCodigoBtn: GSVCButton! {
        didSet {
            if let image = UIImage(named: "unhideSAIcon")?.withRenderingMode(.alwaysTemplate).tint(with: ColorStyle.GSVCText100.color ) {
                generaCodigoBtn.setImage(image, for: .normal)
                generaCodigoBtn.tintColor = ColorStyle.GSVCText100.color
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: xibName, bundle: Bundle(for: BASAScanCodeButtonsViewController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: xibName, bundle: Bundle(for: BASAScanCodeButtonsViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonTitle(isHidden: true)
  
    }
    
    public func setButtonTitle(isHidden: Bool){
        let imgIcon = UIImage(named: isHidden ? "unhideSAIcon" : "hideSAIcon")?.withRenderingMode(.alwaysTemplate).tint(with: ColorStyle.GSVCText100.color)
        generaCodigoBtn.setImage(imgIcon, for: .normal)
        generaCodigoBtn.setTitle(isHidden ? "Genera código de pago" : "Oculta código de pago", for: .normal)
        generaCodigoBtn.setTitle(isHidden ? "Genera código de pago" : "Oculta código de pago", for: .normal)
    }
    
    @IBAction func onClickCodeGenerate(){
        delegate?.onClickGenerateBtn()

    }
    
    @IBAction func showAndHidePanel(_ sender: GSVCButton) {
        delegate?.showAndHidePanel(sender)
    }
}
