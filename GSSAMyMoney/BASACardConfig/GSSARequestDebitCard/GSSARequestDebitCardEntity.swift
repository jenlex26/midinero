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
