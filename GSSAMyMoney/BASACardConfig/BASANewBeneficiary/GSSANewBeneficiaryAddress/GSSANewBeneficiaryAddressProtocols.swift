//
//  GSSANewBeneficiaryAddressProtocols.swift
//  GSSAMyMoney
//
//  Created Desarrollo on 30/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol GSSANewBeneficiaryAddressWireframeProtocol: class {

}
//MARK: Presenter -
protocol GSSANewBeneficiaryAddressPresenterProtocol: class {

}

//MARK: Interactor -
protocol GSSANewBeneficiaryAddressInteractorProtocol: class {

  var presenter: GSSANewBeneficiaryAddressPresenterProtocol?  { get set }
}

//MARK: View -
protocol GSSANewBeneficiaryAddressViewProtocol: class {

  var presenter: GSSANewBeneficiaryAddressPresenterProtocol?  { get set }
}