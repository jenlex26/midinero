//
//  BASACardsdashboardEntity.swift
//  GSSAFront
//
//  Created by BranchbitG on 16/06/21.
//

import Foundation


// MARK: - GenericRawResponse
struct GenericRawLendsResponse: Codable {
    var body: LendsResponse?
    var statusCode: String?
    var statusCodeValue: Int?
}

// MARK: - LendsResponse
struct LendsResponse: Codable {
    var mensaje, folio: String?
    var resultado: LendsResponseResult?
}

// MARK: - Prestamos Resultado
struct LendsResponseResult: Codable {
    var fechaProximoPago, fechaProximoPagoDesarrollada: String?
    var pagoPuntual, pagoNormal, pagoSugerido, pagoRequerido: Int?
    var pagoLiquidar: Int?
    var productos: [LendsResponseProducts]?
}

// MARK: - Prestamos Producto
struct LendsResponseProducts: Codable {
    var id: Int?
    var descripcion, pagoPuntual, pagoNormal, pagoSugerido: String?
    var pagoLiquidar, pagoRequerido: String?
}
