//
//  GSSACardFundResumePresenter.swift
//  GSSAMyMoney
//
//  Created Usuario Phinder 2021 on 03/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import baz_ios_sdk_link_pago

class GSSACardFundResumePresenter: GSSACardFundResumePresenterProtocol {
    weak private var view: GSSACardFundResumeViewProtocol?
    var interactor: GSSACardFundResumeInteractorProtocol?
    private let router: GSSACardFundResumeWireframeProtocol

    init(interface: GSSACardFundResumeViewProtocol, interactor: GSSACardFundResumeInteractorProtocol?, router: GSSACardFundResumeWireframeProtocol) {
        self.view = interface
        self.interactor = interactor
        self.router = router
    }
    
    func enroll(request: LNKPG_EnrollmentRequestFacade) {
        interactor?.enroll(request: request)
    }
    
    func enrollSuccess(responseEnroll: LNKPG_EnrollmentResponseFacade, responseOtp: LNKPG_SessionOTPResponseFacade?, responseCargo: LNKPG_CargoEcommerceResponseFacade?, responseFondeo: LNKPG_FondeoAccountResponseFacade?) {
        view?.enrollSuccess(responseEnroll: responseEnroll, responseOtp: responseOtp, responseCargo: responseCargo, responseFondeo: responseFondeo)
    }
    
    func enrollError() {
        view?.enrollError()
    }
    
    func goToTicket(folio: String) {
        router.goToTicket(folio: folio)
    }
    
    func goToError(message: String, isDouble: Bool) {
        router.goToError(message: message, isDouble: isDouble)
    }
    
    func goToNextFlow() {
        router.goToNextFlow()
    }
    
    func returnTo(vc: AnyClass, animated: Bool) {
        router.returnTo(vc: vc, animated: animated)
    }
    
    func getEccomerceInformation() {
        interactor?.getEccomerceInformation()
    }
    
    func getEccomerceInformationError() {
        view?.enrollError()
    }
    
    func getEccomerceSMTInformationSuccess() {
        view?.getEccomerceSMTInformationSuccess()
    }
}
