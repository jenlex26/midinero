//
//  GSSANewBeneficiaryEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 09/07/21.
//

import Foundation

// MARK: - NewBeneficiaryBody
struct NewBeneficiaryBody: Codable {
    var numeroCuenta: String?
    var beneficiarios: [Beneficiario]?
}

// MARK: - Beneficiario
struct Beneficiario: Codable {
    var id, nombre, apellidoPaterno, apellidoMaterno: String?
    var fechaNacimiento, idParentesco, porcentaje: String?
    var domicilio: NewBeneficiaryBodyAddress?
    var contacto: NewBeneficiaryBodyContact?
}

// MARK: - Contacto
struct NewBeneficiaryBodyContact: Codable {
    var claveLada, numeroTelefono, numeroExtension, correoElectronico: String?
}

// MARK: - Domicilio
struct NewBeneficiaryBodyAddress: Codable {
    var calle, numeroExterior, numeroInterior, colonia: String?
    var municipio, estado, codigoPostal: String?
}
