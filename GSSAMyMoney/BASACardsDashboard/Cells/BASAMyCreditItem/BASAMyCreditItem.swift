//
//  BASAMyCreditItem.swift
//  GSSAFront
//
//  Created by Desarrollo on 17/06/21.
//

import UIKit
import GSSAVisualComponents

class BASAMyCreditItem: UITableViewCell {
    
    @IBOutlet weak var lblTitle: GSVCLabel!
    @IBOutlet weak var lblSubTitle: GSVCLabel!
    @IBOutlet weak var lblAmount: GSVCLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func setTitle(id: Int){
        var title = ""
        switch id{
        case 0:
            title = "Todos mis créditos"
        case 1:
            title =  "Crédito Consumo"
        case 2:
            title =  "Crédito Personal"
        case 3:
            title =  "Vivienda"
        case 4:
            title = "Autos"
        case 5:
            title = "Cobranza Externos"
        case 6:
            title = "Nuevos Negocios"
        case 7:
            title = "Telefonia"
        case 8:
            title = "Prestamos a Empleados"
        case 9:
            title = "Creditos Grandes"
        case 10:
            title = "Pymes"
        case 11:
            title = "Cartera Iusacell Masivo"
        case 12:
            title = "Cartera Iusacell Pyme"
        case 13:
            title = "Cartera Iusacell Corporativo"
        case 14:
            title = "Cartera Iusacell Gobierno"
        case 17:
            title = "Tarjeta Azteca"
        case 20:
            title = "CREDITO OUI"
        case 21:
            title = "Credito Italika"
        case 22:
            title = "Crédito Nómina"
        case 23:
            title = "Crédito Nómina Azteca"
        case 24:
            title = "Tarjeta de Credito Elektra"
        case 25:
            title = "Adelanto de Nómina"
        case 94:
            title = "Credimax"
        case 999:
            title = "Plan de Pago"
        default:
            title = ""
        }
        lblTitle.text = title
    }
}
