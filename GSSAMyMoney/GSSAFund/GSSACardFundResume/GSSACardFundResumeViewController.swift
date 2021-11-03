//
//  GSSACardFundResumeViewController.swift
//  GSSAMyMoney
//
//  Created Usuario Phinder 2021 on 03/08/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSAInterceptor
import baz_ios_sdk_link_pago
import GSSASessionInfo

class GSSACardFundResumeViewController: GSVTGenericResumeViewController, GSVCBottomAlertHandler {
    var bottomAlert: GSVCBottomAlert?
    

	var presenter: GSSACardFundResumePresenterProtocol?
    var dailyLimit: Bool = false
    var monthlyLimit: Bool = false
    var numDailyTransactions: Int = 0
    var numMonthlyTransactions: Int = 0
    var dailyTransactionsLimit: Int = 0
    var montlyTransactionsLimit: Int = 0
    
    
    //MARK: - Life cycle
	override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recarga tu tarjeta"
        configureCells()
        configureComponents()
        createTag(eventName: .pageView, section: "mi_dinero", flow: "fondear_cuenta", screenName: "resumen", origin: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        setProgressLine(value: 0.75, animated: true)
    }
}

//MARK: - Presenter Methods
extension GSSACardFundResumeViewController: GSSACardFundResumeViewProtocol {
    func getEccomerceSMTInformationSuccess() {
     
        dailyLimit = GSSAFundSharedVariables.shared.ecommerceSMTIResponse?.limiteDiario ?? false
        monthlyLimit = GSSAFundSharedVariables.shared.ecommerceSMTIResponse?.limiteMensual ?? false
        numDailyTransactions = GSSAFundSharedVariables.shared.ecommerceSMTIResponse?.numeroTransaccionesDiarias ?? 0
        numMonthlyTransactions = GSSAFundSharedVariables.shared.ecommerceSMTIResponse?.numeroTransaccionesMensuales ?? 0
        
        dailyTransactionsLimit = GSSAFundSharedVariables.shared.ecommerceResponse?.limiteTransaccionesDia ?? 0
        montlyTransactionsLimit = GSSAFundSharedVariables.shared.ecommerceResponse?.limiteTransaccionesMes ?? 0
    
//        guard dailyLimit, numDailyTransactions < dailyTransactionsLimit else {
//            self.presentBottomAlertFullData(status: .error, message: "Excedió número de transacciones diarios permitidos", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
//            GSVCLoader.hide()
//            return
//        }
        
        guard monthlyLimit, numMonthlyTransactions < montlyTransactionsLimit else {
            self.presentBottomAlertFullData(status: .error, message: "Excedió número de transacciones mensuales permitidos", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            GSVCLoader.hide()
            return
        }
        
        guard let enrollRequest = GSSAFundSharedVariables.shared.enrollmentRequest else { return }
        presenter?.enroll(request: enrollRequest)
    }
    
    func enrollSuccess(responseEnroll: LNKPG_EnrollmentResponseFacade, responseOtp: LNKPG_SessionOTPResponseFacade?, responseCargo: LNKPG_CargoEcommerceResponseFacade?, responseFondeo: LNKPG_FondeoAccountResponseFacade?) {
        GSVCLoader.hide()

        GSSAFundSharedVariables.shared.enrollmentResponse = responseEnroll
        
        if let responseOtp = responseOtp {
            GSSAFundSharedVariables.shared.sessionOTPResponse = responseOtp
            
            presenter?.goToNextFlow()
            return
        }
        
        if responseCargo != nil || responseFondeo != nil {
            GSSAFundSharedVariables.shared.cargoEcommerceResponse = responseCargo
            GSSAFundSharedVariables.shared.fondeoAccountResponse = responseFondeo
            createTag(eventName: .fondearCuentaSuccess, section: "mi_dinero", flow: "fondear_cuenta", screenName: "dinero_recibido", type: "", element: "", origin: "", amount: responseFondeo?.monto?.moneyToDoubleString())
            let folio = responseCargo?.folioOperacion ?? responseFondeo?.folioOperacion ?? ""
            
            presenter?.goToTicket(folio: folio)
        }
    }
    
    func enrollError() {
        GSVCLoader.hide()
        showError()
    }
    
}

//MARK: - GSVCSliderButtonDelegate
extension GSSACardFundResumeViewController: GSVCSliderButtonDelegate {
    func slideDidFinish(_ sender: GSVCSliderButton) {
        sender.resetSliderState(animated: true)
        GSVCLoader.show()
        presenter?.getEccomerceInformation()
    }
}

//MARK: - GSVTTicketOperationDelegate
extension GSSACardFundResumeViewController: GSVTTicketOperationDelegate {
    func operationSuccessActionClosed() {
        GSINAdminNavigator.shared.releaseLastFlow()
    }
}

//MARK: - Private functions
extension GSSACardFundResumeViewController {
    private func showError() {
        let message = "Ocurrio un error intentelo más tarde"
        
        presenter?.goToError(message: message, isDouble: false)
    }
    
    private func configureCells() {
        var cells:[GSVTResumeCellInfo] = []
        let account: String = GSSAFundSharedVariables.shared.cardInformation?.card?.number ?? ""
        
        let origin = GSVTResumeCellInfo(sectionTitle: "Desde qué tarjeta recargas", mainInfo: account.maskedAccount, iconImage: UIImage(named: "paypalCardSAIcon"), nameAction: "Editar") {
            
            self.presenter?.returnTo(vc: GSSAFundSelectCardViewController.self, animated: false)
        }
        
        let amount = GSVTResumeCellInfo(sectionTitle: "Cuánto quieres recargar",
                                        mainInfo: "$\(GSSAFundSharedVariables.shared.amount ?? "")",
                                        iconImage: UIImage(named: "ic_pay", in: Bundle(for: GSSACardFundResumeViewController.self), compatibleWith: nil), nameAction: "Editar") {
            self.presenter?.returnTo(vc: GSSALinkDePagoViewController.self, animated: false)
        }
        
        let extraData = GSVTResumeCellInfo(sectionTitle: "Datos de tu recarga",
                                           subTitle: "Comisión",
                                           mainInfo: "$\(GSSAFundSharedVariables.shared.ecommerceResponse?.comisionTransaccion ?? "0.00")",
                                           iconImage: UIImage(named: "legalInfoSAIcon"))
        
        cells.append(origin)
        cells.append(amount)
        cells.append(extraData)
        
        tableView.data = cells
    }
    
    private func configureComponents() {
        btnContinue = GSVCSliderButton(
            delegate: self,
            strInstruction: "Desliza para recargar",
            withSuccesText: true,
            thumbnailImage: UIImage(named: "arrastrar3"),
            frame: CGRect(x: 0,y: 0, width: self.view.frame.width, height: 64)
        )
    }
    
    private func showBottomAlert(msg: String) {
        self.presentBottomAlertFullData(status: .caution, message: msg, attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
    }
    
}


