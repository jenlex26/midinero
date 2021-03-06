//
//  GSSALinkDePagoProtocols.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 12/07/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation
import UIKit

//MARK: Wireframe -
protocol GSSALinkDePagoWireframeProtocol: AnyObject {
    func showError(_ view: UIViewController)
    func showAlert(_ view: UIViewController) 
}
//MARK: Presenter -
protocol GSSALinkDePagoPresenterProtocol: AnyObject {
    func requestMailUpdate(body: UpdateMailBody, Response: @escaping (DigitalCardResponse?) -> ())
    
    func getEccomerceInformation()
    
    func getEccomerceInformationSuccess()
    
    func getEccomerceInformationError()
    func showError(_ view: UIViewController)
    func showAlert(_ view: UIViewController) 
}

//MARK: Interactor -
protocol GSSALinkDePagoInteractorProtocol: AnyObject {
  var presenter: GSSALinkDePagoPresenterProtocol?  { get set }
    func tryMailUpdate(body: UpdateMailBody, Response: @escaping (DigitalCardResponse?) -> ())
    func getEccomerceInformation()
}

//MARK: View -
protocol GSSALinkDePagoViewProtocol: AnyObject {

  var presenter: GSSALinkDePagoPresenterProtocol?  { get set }
    
    
    func getEccomerceInformationSuccess()
    
    func getEccomerceInformationError()
}
