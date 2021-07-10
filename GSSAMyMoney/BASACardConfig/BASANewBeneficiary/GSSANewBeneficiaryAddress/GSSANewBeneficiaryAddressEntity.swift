//
//  GSSANewBeneficiaryAddressEntity+.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 10/07/21.
//

import Foundation

struct zipResponse: Codable{
    let mensaje     : String?
    let folio       : String?
    let resultado   : ZIPResult?
    var detalles    : [String]?
}

struct ZIPResult: Codable{
    let idPais      : Int?
    let pais        : String?
    let idEstado    : Int?
    let estado      : String?
    let idMunicipio : Int?
    let municipio   : String?
    let colonias    : [colonias]?
}

struct colonias: Codable{
    let id      : Int?
    let nombre  : String?
}
