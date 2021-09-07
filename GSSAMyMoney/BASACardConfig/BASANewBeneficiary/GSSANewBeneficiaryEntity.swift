//
//  GSSANewBeneficiaryEntity.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 09/07/21.
//

import Foundation
import UIKit

// MARK: - NewBeneficiaryBody
struct NewBeneficiaryBody: Codable {
    var numeroCuenta: String?
    var beneficiarios: [Beneficiario]?
}

// MARK: - Beneficiario
struct Beneficiario: Codable {
    var id, nombre, apellidoPaterno, apellidoMaterno: String?
    var fechaNacimiento, idParentesco, porcentaje: String?
    var domicilio: BeneficiaryAddress?
    var contacto: BeneficiaryContact?
}


struct pickerTextField{
    var pickerOptions: [String]?
    var datePicker: Bool
    var dateFormat: String?
}

struct beneficiaryField{
    var title: String
    var image: UIImage?
    var placeHolder: String?
    var pickerData: pickerTextField?
    var size: cellSize?
    var keyboardType: UIKeyboardType?
    var text: String?
    var index: Int?
    var height: CGFloat?
    var tag: Int?
    var isEnabled: Bool?
}

struct beneficiaryPercents{
    var name: String
    var percent: String
    var id: String
}

enum cellSize{
    case small
    case normal
}

//Temporaly stores new beneficiary Data
public struct beneficiaryPublicData {
    static var shared = beneficiaryPublicData()
    var id                  : String?
    var nombre              : String?
    var apellidoPaterno     : String?
    var apellidoMaterno     : String?
    var fechaNacimiento     : String?
    var idParentesco        : String?
    var porcentaje          : String?
    var domicilio           : Bool?
    var calle               : String?
    var numeroExterior      : String?
    var numeroInterior      : String?
    var colonia             : String?
    var municipio           : String?
    var estado              : String?
    var codigoPostal        : String?
    var pais                : String?
    var contacto            : Bool?
    var claveLada           : String?
    var numeroTelefono      : String?
    var numeroExtension     : String?
    var correoElectronico   : String?
    private init() { }
}
