//
//  GSSACardNIPEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 12/08/21.
//

import Foundation

// MARK: - RequestNIPBody
struct RequestNIPBody: Codable {
    var transaccion: RequestNIPTransaccion?
}

// MARK: - Transaccion
struct RequestNIPTransaccion: Codable {
    var primerTokenVerificacion: String?
    var tarjeta: RequestNIPCard?
    var clienteUnico: ClienteUnico?
}

// MARK: - ClienteUnico
struct ClienteUnico: Codable {
    var idPais, idCanal, idSucursal, folio: String?
}

// MARK: - Tarjeta
struct RequestNIPCard: Codable {
    var numero, numeroContrato, codigoSeguridad, idCliente: String?
}

