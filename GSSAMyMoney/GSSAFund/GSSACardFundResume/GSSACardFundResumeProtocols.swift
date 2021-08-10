//
//  GSSACardFundResumeProtocols.swift
//  GSSAMyMoney
//
//  Created Usuario Phinder 2021 on 03/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation
import baz_ios_sdk_link_pago
//MARK: Wireframe -
protocol GSSACardFundResumeWireframeProtocol: class {
    func goToError(message: String, isDouble: Bool)
    func goToTicket(folio: String)
    func returnTo(vc: AnyClass, animated: Bool)
    func goToNextFlow()
}
//MARK: Presenter -
protocol GSSACardFundResumePresenterProtocol: class {
    func enroll(request: LNKPG_EnrollmentRequestFacade)
    
    func enrollSuccess(responseEnroll: LNKPG_EnrollmentResponseFacade, responseOtp: LNKPG_SessionOTPResponseFacade?, responseCargo: LNKPG_CargoEcommerceResponseFacade?,  responseFondeo: LNKPG_FondeoAccountResponseFacade?)
    func enrollError()
    
    func goToError(message: String, isDouble: Bool)
    func goToTicket(folio: String)
    func returnTo(vc: AnyClass, animated: Bool)
    func goToNextFlow()
}

//MARK: Interactor -
protocol GSSACardFundResumeInteractorProtocol: class {

  var presenter: GSSACardFundResumePresenterProtocol?  { get set }
    
    func enroll(request: LNKPG_EnrollmentRequestFacade)
}

//MARK: View -
protocol GSSACardFundResumeViewProtocol: class {

  var presenter: GSSACardFundResumePresenterProtocol?  { get set }
    
    func enrollSuccess(responseEnroll: LNKPG_EnrollmentResponseFacade, responseOtp: LNKPG_SessionOTPResponseFacade?, responseCargo: LNKPG_CargoEcommerceResponseFacade?,  responseFondeo: LNKPG_FondeoAccountResponseFacade?)
    func enrollError()
}
