//
//  BASACardStatementsEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 23/06/21.
//

import Foundation

// MARK: - DebitCardBody
struct DebitCardStatementBody: Codable {
    let numeroCuenta, fechaInicio, fechaFin: String?
}

// MARK: - DebitCardStatement
struct DebitCardStatementData: Codable {
    var mensaje, folio: String?
    var resultado: StatementResult?
}


// MARK: - DebitCardResultado
struct StatementResult: Codable {
    var numeroCuenta: Int?
    var detalles: [StatementDetail]?
}

// MARK: - DebitCardDetalle
struct StatementDetail: Codable {
    var periodo, fechaInicio, fechaFin: String?
}

