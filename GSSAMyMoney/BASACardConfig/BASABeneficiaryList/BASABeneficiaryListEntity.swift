//
//  BASABeneficiaryListEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 30/06/21.
//

import Foundation


// MARK: - BeneficiaryListBody
public struct BeneficiaryListBody: Codable {
    var numeroCuenta: String?
}

// MARK: - BeneficiaryListResponse
public struct BeneficiaryListResponse: Codable {
    var mensaje, folio: String?
    var resultado: BeneficiaryListResult?
}

// MARK: - Resultado
public struct BeneficiaryListResult: Codable {
    var numeroCuenta: String?
    var beneficiarios: [BeneficiaryItem]?
}

// MARK: - Beneficiario
public struct BeneficiaryItem: Codable {
    var id, idParentesco, nombre, apellidoPaterno: String?
    var apellidoMaterno, fechaNacimiento, porcentaje: String?
    var domicilio: BeneficiaryAddress?
    var contacto: BeneficiaryContact?
}

// MARK: - Contacto
public struct  BeneficiaryContact: Codable {
    var claveLada, numeroTelefono, numeroExtension, correoElectronico: String?
}

// MARK: - Domicilio
public struct BeneficiaryAddress: Codable {
    var calle, numeroExterior, numeroInterior, colonia: String?
    var municipio, estado, codigoPostal: String?
}
