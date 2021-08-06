//
//  GSSAMainHubDebitEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 05/07/21.
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
   // let numeroCuenta: String
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
    var importe, saldo, descripcion, fechaOperacion: String?
    var numeroMovimiento, codigoDivisa: String?
}

// MARK: - MovimientosBodyv2
struct MovimientosBodyv2: Codable {
    var transaccion: MovementsBodyDataV2?
}

struct MovementsBodyDataV2: Codable {
    var sicu, numeroCuenta: String?
    var geolocalizacion: Geolocalizacion?
}

// MARK: - Geolocalizacion
struct Geolocalizacion: Codable {
    var latitud, longitud: String?
}

// MARK: - DebitCardTransactionV2
struct DebitCardTransactionV2: Codable {
    var mensaje, folio: String?
    var resultado: DebitCardTransactionResultV2?
}

// MARK: - Resultado
struct DebitCardTransactionResultV2: Codable {
    var movimientos: [DebitCardTransactionItemV2]?
}

// MARK: - Movimiento
struct DebitCardTransactionItemV2: Codable {
    var idOperacion, idCodigo, idClasificacionProducto, folio: String?
    var fecha, hora, concepto, descripcion: String?
    var importe, indicadorNomina, numeroOperacion: String?
    var descripcionOperacion: String?
    var urlFoto: String?
    var descripcionBeneficiario: String?
    var nombreOrdenante: String?
}
