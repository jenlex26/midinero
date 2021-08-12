//
//  GSSARequestDebitCardEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 09/08/21.
//

import Foundation

// MARK: - PhysicalCardShippingAmountResponse
struct PhysicalCardShippingAmountResponse: Codable {
    var mensaje, folio: String?
    var resultado: PhysicalCardShippingAmountResult?
}

// MARK: - Resultado
struct PhysicalCardShippingAmountResult: Codable {
    var monto: String?
}

// MARK: - ConfirmCardRequestBody
struct ConfirmCardRequestBody: Codable {
    var transaccion: ConfirmCardRequestTransaccion?
}

// MARK: - Transaccion
struct ConfirmCardRequestTransaccion: Codable {
    var primerTokenVerificacion, sicu, numeroCuenta: String?
    var envio: Envio?
}

// MARK: - Envio
struct Envio: Codable {
    var comision, idTipoTarjeta: String?
    var cliente: ConfirmCardRequestTransaccionClient?
    var domicilio: Domicilio?
}

// MARK: - Cliente
struct ConfirmCardRequestTransaccionClient: Codable {
    var nombre, numeroTelefonico: String?
}

// MARK: - Domicilio
struct Domicilio: Codable {
    var ciudad, calle, colonia, codigoPostal: String?
    var numeroExterior, numeroInterior: String?
}


// MARK: - BearerTokenResponse
struct BearerTokenResponse: Codable {
    var accessToken: String?
    var expiresIn: Int?
    var tokenType: String?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}
