//
//  GSSAFundTicket.swift
//  GSSAMyMoney
//
//  Created by Usuario Phinder 2021 on 10/08/21.
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSASessionInfo
import GSSAInterceptor

class GSSAFundTicket: UIViewController {
    private static func getTicketInfo() -> [GSVTResumeCellInfo] {
        var cells: [GSVTResumeCellInfo] = []
        
        let account: String = GSSAFundSharedVariables.shared.cardInformation?.card?.number?.maskedAccount ?? ""
        let mainAccount: String = GSSISessionInfo.sharedInstance.gsUser.account?.card?.maskedAccount ?? ""
        
        let extraData = GSVTResumeCellInfo(sectionTitle: "Detalle del envío",
                                           subTitle: "Envío a cuenta",
                                           mainInfo: "Tarjeta baz \(account)",
                                           iconImage: nil)
        
        let origin = GSVTResumeCellInfo(sectionTitle: "Cuenta origen",
                                        mainInfo: mainAccount,
                                        iconImage: nil)

        cells.append(extraData)
        cells.append(origin)
        return cells
    }
    
    static func createTicket(folio: String, delegate: GSVTTicketOperationDelegate) -> UIViewController {

        let amount = GSSAFundSharedVariables.shared.amount ?? ""
        let comission: String = GSSAFundSharedVariables.shared.ecommerceResponse?.comisionTransaccion ?? "0.00"
        let operationInfo = GSSAFundTicket.getTicketInfo()
        let amountFormat = NSMutableAttributedString.setFormattedText(withStringAmmount: amount.replacingOccurrences(of: "$", with: ""),
            withNumberOfDecimals: 2,
            withFontSize: 36,
            withFontWeight: .medium,
            withFontColor: .GSVCText100,
            withLittleCoin: true)
        
        let mainInfo = GSVTTicketMainInfo(title: "Dinero recibido -\nComisión $\(comission).00" ,operationAttributed: amountFormat)
        let ticket = GSVTTicketOperationController(delegate: delegate, mainInfo: mainInfo, operationInfo: operationInfo, generatedInfo: [(subTitle: "Folio", info: folio)], aditionalInfo: [], mainActionTitle: nil, hasSecundaryAction: true, firstActionTitle: "Compartir", firstAction: nil, secundaryActionTitle: nil, tagTicketDelegate: nil, titleBtnReturn: "Volver al inicio")
        
        return ticket
        
    }
}

//MARK: - GSVTTicketOperationDelegate
extension GSSAFundTicket: GSVTTicketOperationDelegate {
    func operationSuccessActionClosed() {
        GSINAdminNavigator.shared.releaseLastFlow()
    }
}
