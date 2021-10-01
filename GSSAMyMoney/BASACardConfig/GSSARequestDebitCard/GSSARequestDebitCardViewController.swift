//
//  GSSARequestDebitCardViewController.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 28/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents
import GSSAVisualTemplates
import GSSASessionInfo
import GSSAPermissionsManager

class GSSARequestDebitCardViewController: GSSAMasterViewController, GSSARequestDebitCardViewProtocol, GSVCBottomAlertHandler {
    
    @IBOutlet weak var headerView               : UIView!
    @IBOutlet weak var containerView            : UIView!
    @IBOutlet weak var gradientView             : Gradient!
    @IBOutlet weak var lblAddress               : UILabel!
    @IBOutlet weak var lblShippingCost          : GSVCLabel!
    @IBOutlet weak var lblShippingCostSubtitle  : GSVCLabel!
    @IBOutlet weak var btnNext                  : GSVCButton!
    
    var bottomAlert: GSVCBottomAlert?
    var presenter: GSSARequestDebitCardPresenterProtocol?
    var isViewDidLoad = false
    var amount = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerView.backgroundColor = UIColor.GSVCBase300()
        containerView.layer.cornerRadius = 10.0
        gradientView.layer.cornerRadius = 10.0
        setAddress()
        activityObserved()
        getShippingAmount()
        isViewDidLoad = true
        NotificationCenter.default.addObserver(self, selector: #selector(retryRequest), name: NSNotification.Name(rawValue: "RetryRequest"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeView), name: NSNotification.Name(rawValue: "ExitFlow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeCardRequest), name: NSNotification.Name(rawValue: "SlideComplete"), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if isViewDidLoad == true{
            isViewDidLoad = false
        }else{
            let address = requestedAddress.shared
            lblAddress.text = "\((address.street ?? "").capitalized) \((address.externalNumber ?? "").capitalized) \((address.suburb ?? "").capitalized) \((address.city ?? "").capitalized) \(address.postalCode ?? "")"
        }
    }
    
    @objc func retryRequest(){
        activityObserved()
        getShippingAmount()
    }
    
    @objc func closeView(){
        activityObserved()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func makeCardRequest(){
        GSVCLoader.show()
        presenter?.requestCard(commission: amount.moneyToDoubleString(), Response: { Response in
            if Response != nil{
                self.present(GSSARequestDebitCardGenericTicket.getGenericTicket(delegate: self), animated: true)
            }else{
                self.presentBottomAlertFullData(status: .error, message: "Ocurrió un problema al solicitar su tarjeta, intente de nuevo más tared", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            }
            GSVCLoader.hide()
        })
    }
    
    func getShippingAmount(){
        GSVCLoader.show()
        let transaction = PhysicalCardShippingAmountTransaction.init(transaccion: PhysicalCardShippingAmountBody.init(numeroTarjeta: GSSISessionInfo.sharedInstance.gsUser.account?.card?.encryptAlnova(), primerTokenVerificacion: customToken.shared.firstVerification, geolocalizacion: ShippingAmountLocation.init(latitud: (GSPMLocationManager.shared.lastLocation?.coordinate.latitude.description.encryptAlnova() ?? "0.0".encryptAlnova()), longitud: (GSPMLocationManager.shared.lastLocation?.coordinate.longitude.description.encryptAlnova() ?? "0.0".encryptAlnova()))))
        
        presenter?.requestGetShippingCost(body: transaction, Response: { [self] Response in
            if Response != nil{
                amount = Response?.resultado?.montoTotal?.alnovaDecrypt().moneyFormatWithoutSplit() ?? ""
                    lblShippingCost.text = "Solicítala con un costo de \(Response?.resultado?.montoTotal?.alnovaDecrypt().moneyFormatWithoutSplit() ?? "")"
                    self.lblShippingCostSubtitle.text = "Solicítala con un costo de \(Response?.resultado?.montoTotal?.alnovaDecrypt().moneyFormatWithoutSplit() ?? "")"
                requestedAddress.shared.amount = amount
                 GSVCLoader.hide()
            }else{
                GSVCLoader.hide()
               let view = showErrorViewController(message: "Ocurrió un error")
               self.present(view, animated: true, completion: nil)
            }
        })
    }
    
    func optionalAction() {()}
    
    func setAddress(){
        let address = GSSISessionInfo.sharedInstance.gsUser.address
        lblAddress.text = "\((address?.street ?? "").capitalized) \((address?.externalNumber ?? "").capitalized) \((address?.neighborhood ?? "").capitalized) \((address?.city ?? "").capitalized) \(address?.zipCode ?? "")"
        requestedAddress.shared.street = address?.street
        requestedAddress.shared.externalNumber = address?.externalNumber
        requestedAddress.shared.suburb = address?.neighborhood
        requestedAddress.shared.city = address?.city
        requestedAddress.shared.postalCode = address?.zipCode
    }
    
    @IBAction func next(_ sender: Any){
        activityObserved()
        if amount != ""{
            let actualBalance = (UserDefaults.standard.value(forKey: "debitAccountBalance") as? String)?.moneyToDoubleString()
            let cardCost = amount.moneyToDoubleString()
            if Double(actualBalance ?? "0.0")! >= Double(cardCost) ?? 0.0{
               self.present(GSSACardPaymentBtnCoreViewRouter.createModule(), animated: true)
            }else{
                self.presentBottomAlertFullData(status: .caution, message: "Lo sentimos, no cuenta con saldo suficiente para solicitar la tarjeta", attributedString: nil, canBeClosed: true, animated: true, showOptionalButton: false, optionalButtonText: nil)
            }
        }
    }
    
    @IBAction func editAddress(_ sender: Any){
        let view = GSSAPhysicalCardRequestAddressRouter.createModule()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
}

extension GSSARequestDebitCardViewController : GSVTTicketOperationDelegate{
    func operationSuccessActionClosed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
