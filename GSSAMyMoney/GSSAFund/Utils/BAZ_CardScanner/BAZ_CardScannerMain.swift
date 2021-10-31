//
//  BAZ_CardScannerMain.swift
//  baz-ios-akpago-utils
//
//  Created by Jorge Cruz on 16/06/21.
//

import UIKit

open class BAZ_CardScannerMain: NSObject {

    public static func createModule(navigation : UINavigationController, delegate: BAZ_CardScannerViewDelegate) -> UIViewController{
        
        let viewController  :   BAZ_CardScannerView?   =  BAZ_CardScannerView()
        if let view = viewController {
            view.delegate = delegate
            return view
        }
        return UIViewController()
    }
}
