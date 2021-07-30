//
//  BASAMasterViewController:.swift
//  BASAMyPayments
//
//  Created by Benigno Marin Mendoza on 18/06/21.
//

import UIKit
import GSSAVisualTemplates
import GSSASessionInfo
import GSSAPermissionsManager
import GSSAVisualComponents
import GSSAInterceptor

open class GSSAMasterViewController: GSVTMasterViewController {
    public static var totalOfPages: Float = 1.0
    private var inactivityTimer: Timer?
    private var inactivyTimeout: Date?
    private let inactiviyMaxTime: Double = 300
    private var isBackgroundEventsEnabled = true
    var isMainFlowVC : Bool = false
    open override func viewDidLoad() {
        super.viewDidLoad()
        showProgressLine(value: 0.0, animated: true)
    }
}

extension GSSAMasterViewController {
    func popToViewController(ofClass: AnyClass, animated: Bool = true) {
        if  let nav = self.navigationController,
            let vc = nav.viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            nav.popToViewController(vc, animated: animated)
        }
    }
}


extension GSSAMasterViewController {
    @objc private func closeFlow() {
        GSINAdminNavigator.shared.releaseFlows()
    }
}
