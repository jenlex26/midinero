//
//  BAZ_CardScannerViewView.swift
//  baz-ios-akpago-utils
//
//  Created Jorge Cruz on 15/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

public protocol BAZ_CardScannerViewDelegate: AnyObject {
    func notifyCodeScanner(barcode: BAZ_CardScannerEntity)
}

/// BAZ_CardScannerView Module View
class BAZ_CardScannerView: UIViewController {
    
    private var ui : BAZ_CardScannerViewUI?
    public weak var delegate : BAZ_CardScannerViewDelegate?
    override func loadView() {
        // setting the custom view as the view controller's view
        ui =  BAZ_CardScannerViewUI(delegate: self)
        view = ui
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
}

// MARK: - extending SerialNumberView to implement the custom ui view delegate
extension BAZ_CardScannerView: BAZ_CardScannerViewUIDelegate {
    func notifyDissmissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func notifySuccesfulScan(barcode: BAZ_CardScannerEntity) {
        delegate?.notifyCodeScanner(barcode: barcode)
       // presenter?.requestNextStepWithBarCode(code: barcode)
    }
}
