//
//  BASAScanCodeViewController.swift
//  BASAMyPaymentsScreens
//
//  Created by Benigno Marin Mendoza on 03/06/21.
//

import UIKit
import AVFoundation
import GSSAVisualTemplates
import GSSAVisualComponents

class BASAScanCodeViewController: GSVTCodeScanner, BASAScanCodeViewProtocol, GSVTCodeScannerDelegate {
    var presenter: BASAScanCodePresenterProtocol?
    var codeScanner: GSVTCodeScanner?
    let scanCodeButtonsViewController = BASAScanCodeButtonsViewController()
    var frameHidePanel: CGRect?
    var frameShowPanel: CGRect?
    var hidePanel: Bool = true
    var secuence: GSSAMyMoneyScanSecuence?
    
    //MARK: Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.delegate = self
        if secuence == .scanCarCode {
            self.arrValidCodeTypes =  [.qr]
            
        } else{
            self.arrValidCodeTypes =  [.code128 ]
        }
        scanCodeButtonsViewController.view.isHidden = secuence != .scanCarCode
        NotificationCenter.default.addObserver(self, selector: #selector(dismissView), name: NSNotification.Name(rawValue: "closeScanner"), object: nil)
        scanCodeButtonsViewController.delegate = self
    }
    
    @objc func dismissView(){
        self.dismiss(animated: false, completion: {
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "closeValidateView"), object: nil, userInfo: nil))
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        self.view.addSubview(scanCodeButtonsViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        frameHidePanel = CGRect.init(x: 0,
                                     y: self.view.frame.size.height - scanCodeButtonsViewController.view.frame.size.height/3,
                                     width: self.view.frame.size.width,
                                     height: scanCodeButtonsViewController.view.frame.size.height)
        
        frameShowPanel = CGRect.init(x: 0,
                                     y:  self.view.frame.size.height - (self.scanCodeButtonsViewController.view.frame.size.height - 10),
                                     width: self.view.frame.size.width,
                                     height: self.scanCodeButtonsViewController.view.frame.size.height)
        
        
        scanCodeButtonsViewController.view.frame = (hidePanel ? frameHidePanel : frameShowPanel) ?? .zero
        
    }
    
    //MARK: GSVTCodeScannerDelegate -
    func codeDetected(sCode: String) {
        scanCodeButtonsViewController.view.removeFromSuperview()
        hidePanel = true
        presenter?.codeDetected(sCode: sCode)
    }
    
    func cancelCodeScanner() {
        presenter?.cancelCodeScanner()
    }
}


extension BASAScanCodeViewController: BASAScanCodeButtonsViewControllerDelegate {
    func showAndHidePanel(_ sender: GSVCButton) {        
        UIView.animate(withDuration: 0, animations: {
            self.hidePanel = !self.hidePanel
            if !self.hidePanel{
                
            }
            self.scanCodeButtonsViewController.view.frame = (self.hidePanel ? self.frameHidePanel : self.frameShowPanel) ?? .zero
        }, completion: {_ in 
            self.scanCodeButtonsViewController.setButtonTitle(isHidden: self.hidePanel)
        })
        
    }
    
    func onClickGenerateBtn() {()}
}

