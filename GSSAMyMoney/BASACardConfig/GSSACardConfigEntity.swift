//
//  GSSACardConfigEntity.swift
//  GSSAMyMoney
//
//  Created by Desarrollo on 10/08/21.
//

import Foundation


public struct customToken{
    static var shared = customToken()
    var bearer = "eyJraWQiOiJkczdRNlBTbE9ZNStuMnJjXC9PdjJqTGp5eWZRS2VJdmFjRXcwWHlNQm80cz0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIxOGg4dmFudnJoNHB1aTFscm50YzFuaWxqZiIsInRva2VuX3VzZSI6ImFjY2VzcyIsInNjb3BlIjoiVXN1YXJpb1wvZGVsZXRlIFVzdWFyaW9cL3JlYWQgVXN1YXJpb1wvdXBkYXRlIiwiYXV0aF90aW1lIjoxNjI4NzkxOTI0LCJpc3MiOiJodHRwczpcL1wvY29nbml0by1pZHAudXMtZWFzdC0xLmFtYXpvbmF3cy5jb21cL3VzLWVhc3QtMV9FaEZuSU9JRzAiLCJleHAiOjE2Mjg3OTU1MjQsImlhdCI6MTYyODc5MTkyNCwidmVyc2lvbiI6MiwianRpIjoiZWM1ODg0NjAtYjAwYS00ZThhLTlkZmUtZjE0MzVhZjhmNmFhIiwiY2xpZW50X2lkIjoiMThoOHZhbnZyaDRwdWkxbHJudGMxbmlsamYifQ.ARQFfuRH-968Ak_xx-u_KrZmFbigLxOsXdWpIk0b4Y34UfM6b3r43ONHMKvQClE4NqQw9M7udbYmSwfIav7WA8WsNK5dqGCJOY6B62tCez8-sJxuVULIjA_cIP3SMtosRyh36W9B4Aw2uLDozuXBSMdUy1cpGrPjfqDUgjgZ7JTf-sildR7fZjaX51w9h2kgkQKF0Ri4WRJwt-gsft7R5_Rp-uz6gWiX5Tlg3dOMav_0k_s5mpiZ0AKjF3yu-yznd8GXBsHdNIQBnHSIgod0x3Xsavs0iHUMdJ3hg5tDHhI8OK35UDyk59IlHIQ7ohyIPqcvelYTNQT0h7emtAgl9Q"
    private init() { }
}


// MARK: - CardConfigCardSearchBody
struct CardConfigCardSearchBody: Codable {
    var transaccion: CardConfigCardSearchTransaccion?
}

// MARK: - Transaccion
struct CardConfigCardSearchTransaccion: Codable {
    var primerTokenVerificacion, sicu, numeroCuenta, idTipoTarjeta: String?
}
