//
//  BASAA.swift
//  Adquirente
//
//  Created by Usuario Phinder 2020 on 05/07/21.
//

import UIKit
import GSSAInterceptor
import GSSAFunctionalUtilities

public class BASAADefinition: GSINEnviromentDefinition {
    public static var enviroment: GSSAFunctionalUtilities.GSFUModuleEnviroment = .develop

    public static func registerActions() {
        GSINAdminNavigator.shared.registerFlow(witNavigateItem: BASAAdquiriente.self)
    }
}

public class BASAAdquiriente: GSINNavigateItem {
    public static var moduleName: String { "GSIFAd" }

    
    /// Función lanzadora del modulo de Abono de Saldo SApp, PONER ATENCIÓN A LA DESCRIPCIÓN DE PARAMETROS
    /// ```
    /// var amount: String // 500000.00
    /// var numeroCuentaCliente: String // Cuenta 14 Digitos Cifrado ALNOVA
    /// var merchantDetail: String // Detalle de la petición
    /// var correo: String // Dependiendo el correo es las cuentas de regresa de VISA
    ///
    /// Exmaple:
    /// ["amount": "50.00", "numeroCuentaCliente": "k_BV6qGZCotcv36s_Ui8dw","merchantDetail":"Abono Saldo", "correo": "testVisaFake@bancoazteca.com.mx", "numeroAfiliacion":"8632464"]
    /// ```
    /// - Parameter parameters: ["amount":"5.00", "numeroCuentaCliente":"Cuenta14-CifradoALNOVA","merchantDetail": "Abono Súper App","correo":"testVisaFake@bancoazteca.com.mx"]
    /// - Returns: UIViewController
    public static func createModule(withInfo parameters: [String : Any]?) -> UIViewController {
        //let validado = validateStrings(parameters: parameters)
        return GSSALinkDePagoRouter.createModule()
    }
}
