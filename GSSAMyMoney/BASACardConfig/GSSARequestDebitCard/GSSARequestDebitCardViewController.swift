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
import GSSAInterceptor

class GSSARequestDebitCardViewController: UIViewController, GSSARequestDebitCardViewProtocol, GSINNavigateDelegate, GSVCBottomAlertHandler {
    
    @IBOutlet weak var headerView               : UIView!
    @IBOutlet weak var containerView            : UIView!
    @IBOutlet weak var gradientView             : Gradient!
    @IBOutlet weak var lblAddress               : UILabel!
    @IBOutlet weak var lblShippingCost          : GSVCLabel!
    @IBOutlet weak var lblShippingCostSubtitle  : GSVCLabel!
    @IBOutlet weak var btnNext                  : GSVCButton!
    
    var bottomAlert: GSVCBottomAlert?
    var presenter: GSSARequestDebitCardPresenterProtocol?
    
	override func viewDidLoad() {
        super.viewDidLoad()
        headerView.backgroundColor = UIColor.GSVCBase300()
        containerView.layer.cornerRadius = 10.0
        gradientView.layer.cornerRadius = 10.0
        getShippingAmount()
        setAddress()
        NotificationCenter.default.addObserver(self, selector: #selector(parseCustomRequest(notification:)), name: NSNotification.Name(rawValue: "PhysicalCardShippingAmountResponse"), object: nil)
    }
    
    @objc func parseCustomRequest(notification: Notification){
        DispatchQueue.main.async {
            GSVCLoader.hide()
            print("USANDO CUSTOM REQUEST...")
            let data = notification.object as! Data
            let model = try! JSONDecoder().decode(PhysicalCardShippingAmountResponse.self, from: data)
            if model.resultado?.monto == nil{
                self.btnNext.isEnabled = false
                self.presentBottomAlertFullData(status: .error, message: "Ocurrió un problema al obtener la información, intente más tarde", attributedString: nil, canBeClosed: false, animated: true, showOptionalButton: true, optionalButtonText:nil)
            }else{
            self.lblShippingCost.text = "Solicítala con un costo de \(model.resultado?.monto?.moneyFormatWithoutSplit() ?? "")"
            self.lblShippingCostSubtitle.text = "Solicítala con un costo de \(model.resultado?.monto?.moneyFormatWithoutSplit() ?? "")"
            }
        }
    }
    
    func getShippingAmount(){
        GSVCLoader.show()
        presenter?.requestGetShippingCost(Response: { [self] Response in
            if Response != nil{
                GSVCLoader.hide()
                lblShippingCost.text = "Solicítala con un costo de \(Response?.resultado?.monto?.moneyFormatWithoutSplit() ?? "")"
                self.lblShippingCostSubtitle.text = "Solicítala con un costo de \(Response?.resultado?.monto?.moneyFormatWithoutSplit() ?? "")"
            }
        })
    }
    
    func optionalAction() {}
    
    func setAddress(){
        let address = GSSISessionInfo.sharedInstance.gsUser.address
        lblAddress.text = "\((address?.street ?? "").capitalized) \((address?.externalNumber ?? "").capitalized) \((address?.neighborhood ?? "").capitalized) \((address?.city ?? "").capitalized) \(address?.zipCode ?? "")"
    }
    
    func didFailToEnterFlow(error: NSError) {
        print("Error...")
    }
    
    func willFinishFlow(withInfo info: [String : Any]?) {
        print("MANDAR A RESUMEN...")
    }
    
    @IBAction func next(_ sender: Any){
        let parameters:[String:Any] =
                                    [
                                        "paymentConfig":
                                            [
                                            "productQuantity":"1",
                                            "commission":"0",
                                            "concept":"Donación",
                                            "idCompany":"",
                                            "idReferencePay":"",
                                            "iva":"0",
                                            "amount":"90",
                                            "requieredBill" : true,
                                            "shippingAmount": "90",
                                            "x-idOperacionConciliacion": ""
                                            ],
                                            "viewConfig" :
                                            [
                                            "txtTitle":"Envío de tarjeta física",
                                            "txtSubtitle":"90",
                                            "txtHelper":"Desde qué cuenta compras",
                                            "txtSlideButton": "Desliza para pagar",
                                            ]
                                    ]
                    
                                GSINAdminNavigator.shared.startFlow(forAction: "GSIFTr_PaymentBTN", navigateDelegate: self, withInfo: parameters)
    }
    
    @IBAction func editAddress(_ sender: Any){
        let view = GSSAPhysicalCardRequestAddressRouter.createModule()
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }

}
