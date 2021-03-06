//
//  GSSARequestDebitCardGenericTicket.swift
//  GSSAMyMoney
//
//  Created by Cristian Eduardo Villegas Alvarez on 11/08/21.
//

import Foundation
import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSAInterceptor
import GSSASessionInfo

class GSSARequestDebitCardGenericTicket
{
    static func getWarningBox(message:String)->UIView {
        let iconimage  = UIImage(named: "GSSAMyMoneyinfoIcon", in: Bundle(for: GSSARequestDebitCardGenericTicket.self),
                                             compatibleWith: nil)
        let icon = UIImageView(image: iconimage)
        icon.frame = CGRect(x: 15,y: 15,width: 30,height: 30)
        let label = GSVCLabel()
        label.frame = CGRect(x: 10, y: 100, width: 250, height: 300)
        label.text = message
        label.numberOfLines = 3
        label.styleType = 6
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        label.center = CGPoint.init(x: 180, y: 45)
        label.textAlignment = NSTextAlignment.left
        let informationview = GSVCView()
        informationview.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        informationview.backgroundColor = .GSVCInformation200
        informationview.style =  GSVCViewStyle.cardview.rawValue
        informationview.addSubview(icon)
        informationview.addSubview(label)
        return informationview
    }
    
    class func getTicketInfo(invoice: String)->[GSVTResumeCellInfo] {
        
        // Payment Detail Configuration Cell Start
        let selectedAddress = requestedAddress.shared
        let  paymentDetailOption:[(subTitle: String?, info: String)] =
            [
                (subTitle: "Tarjeta baz", info: "Pago de \(selectedAddress.amount ?? "tarjeta")"),
                (subTitle: "Número de pedido baz", info: invoice)
            ]
        
        let paymentDetailCell = GSVTResumeCellInfo(sectionTitle: "Detalle del pago",
                                              sectionInfo:  paymentDetailOption,
                                              iconImage: nil)
        // Payment Detail Configuration Cell End
        
        
        let completeName = (GSSISessionInfo.sharedInstance.gsUser.name ?? "") + " "  + (GSSISessionInfo.sharedInstance.gsUser.lastName ?? "") + " " + (GSSISessionInfo.sharedInstance.gsUser.secondLastName ?? "")
        // Address Detail Configuration Cell Start
        
        let addressDetailOption:[(subTitle: String?, info: String)] =
            [
                (subTitle: "Domicilio", info: "\(selectedAddress.street ?? "") \(selectedAddress.externalNumber  ?? "") \(selectedAddress.internalNumber  ?? "" ) \(selectedAddress.postalCode  ?? "" )  \(selectedAddress.suburb  ?? "" )  \(selectedAddress.country  ?? "" )  \(selectedAddress.city  ?? "" )" ),
                (subTitle: "Recibe", info: completeName),
                (subTitle: "Entrega estimada", info: "Entre 2 y 10 días hábiles")
            ]
        
        let addressDetailCell = GSVTResumeCellInfo(sectionTitle: "Detalle del pago",
                                              sectionInfo:  addressDetailOption,
                                              iconImage: nil)
        // Payment Detail Configuration Cell End
        
        
        return [paymentDetailCell,addressDetailCell]
    }
    
    class func getGenericTicket(delegate: GSVTTicketOperationDelegate, invoice: String)-> GSVTTicketOperationController {
        
        //Title Info
        let mainInfo = GSVTTicketMainInfo(title: "Tarjeta en camino")
        
        // Blue Info
        let informationView = getWarningBox(message: "Cuando llegue tu paquete asegúrate de que esté en buenas condiciones")
        
        // Ticket instance
        let ticket = GSVTTicketOperationController(mainInfo: mainInfo, operationInfo: getTicketInfo(invoice: invoice), generatedInfo: nil,aditionalInfo: [informationView], firstActionTitle: "Compartir")
        ticket.modalPresentationStyle = .overCurrentContext
        
        // Ticket delegate
        ticket.ticketDelegate = delegate
       return ticket
    }
}

   
    
    
    
    

