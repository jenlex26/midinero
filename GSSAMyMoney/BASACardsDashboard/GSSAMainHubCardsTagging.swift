//
//  GSSAMainHubCardsTagging.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 20/07/21.
//

import Foundation
import UIKit
import GSSAFirebaseManager

extension BASAMainHubCardsViewController{
    
    private func tagDashboardAndDebitView(){
        let tagEvent = GSSAFirebaseEvent(.custom("pageview")).set(section: "mi_dinero").set(flow: "dashboard").set(screenName: "movimientos")
        GSSAAnalytics.firebase.tracking(event: tagEvent)
    }
    
    
}
