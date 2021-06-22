//
//  GSSAMMDefinition.swift
//  GSSAMyMoney
//
//  Created by Benigno Marin Mendoza on 18/06/21.
//

import GSSAInterceptor
import GSSAFunctionalUtilities
import UIKit

public class GSSAMMDefinition: GSINEnviromentDefinition {
    public static var enviroment: GSSAFunctionalUtilities.GSFUModuleEnviroment = .develop

    public static func registerActions() {
        GSINAdminNavigator.shared.registerFlow(witNavigateItem: GSSAMMItemMyMoney.self)
    }
}

public class GSSAMMItemMyMoney: GSINNavigateItem {
    public static var moduleName: String { "GSIFMn" }

    public static func createModule(withInfo parameters: [String : Any]?) -> UIViewController {
        return BASAMainHubCardsRouter.createModule()
    }
}

/* LLAVES:
 SuperApp    GSIFSa
 Mi Dinero    GSIFMn
 Enrolamiento    GSIFSu
 Transferencias    GSIFTr
 Pago con QR    GSIFPqr
 Cobro con QR    GSIFCqr
 Pago de servicios    GSIFSpy
 Tiempo Aire    GSIFAt
 Mis Préstamos    GSIFLn
 Tarjeta de Crédito    GSIFCc
 Chat    GSIFCh
 Red Social    GSIFSn
 Mi Negocio    GSIFBs
 Mis Compras    GSIFPr
 TV en vivo    GSIFTv
 Música    GSIFMs
 Películas on-demand    GSIFMod
 Mis noticias    GSIFNw
 Mi conectividad    GSIFCn
 Quiero ayudar    GSIFDn
 Perfil    GSIFPr
*/

