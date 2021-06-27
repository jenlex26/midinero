//
//  BASACardsdashboardEntity.swift
//  GSSAFront
//
//  Created by BranchbitG on 16/06/21.
//

import Foundation

// MARK: - Debit Account Info
struct AccountBalanceResult: Codable {
    let mensaje, folio: String
    let resultado: Resultado
}

// MARK: - Debit Account Info Resultado
struct Resultado: Codable {
    let cliente: Cliente?
}

// MARK: - Debit Account Info Cliente
struct Cliente: Codable {
    let nombre, apellidoPaterno, apellidoMaterno: String?
    let cuentas: [Cuenta]?
}

// MARK: - Debit Account Info  Cuenta
struct Cuenta: Codable {
    let alias, numero, numeroTarjeta, clabe, codigoEstatus: String?
    let saldoTotal, saldoRetenido, saldoDisponible: String?
}


// MARK: - DEBIT BALANCE
struct BalanceResult: Codable {
    let saldoDisponible, numeroOperacion, divisa, titularCuenta: String?
    let numeroCuenta, descripcionCuenta, fechaHoraOperacion: String?
}

// MARK: - DEBIT BalanceResponse
struct BalanceResponse: Codable {
    let mensaje, folio: String?
    let resultado: Resultado
}

// MARK: - DEBIT AccountBalance
struct TransationBalanceRequest: Codable {
    let transaccion: TransationItem
}

// MARK: - DEBIT Transaccion
struct TransationItem: Codable {
    let folio: String
    let numeroCuenta: String
}


// MARK: - DEBIT MOVEMENTS BODY
struct MovimientosBody: Codable {
    var transaccion: MovementsBodyData?
}

// MARK: - DEBIT MOVEMENTS BODY
struct MovementsBodyData: Codable {
    let numeroCuenta, fechaInicial, fechaFinal: String?
}

// MARK: - DebitCardTransactionData
struct DebitCardTransaction: Codable {
    let mensaje, folio: String
    let resultado: DebitCardTransactionResult
}

// MARK: - DebitCardTransactionResult
struct DebitCardTransactionResult: Codable {
    let numeroCuenta, producto, titularCuenta, fechaConsulta: String
    let horaConsulta: String
    var movimientos: [DebitCardTransactionItem]
}

// MARK: - DebitCardTransactionItem
struct DebitCardTransactionItem: Codable {
    let importe, saldo, descripcion, fechaOperacion: String?
    let numeroMovimiento, codigoDivisa: String?
}
