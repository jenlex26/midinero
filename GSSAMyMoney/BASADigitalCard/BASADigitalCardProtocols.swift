//
//  BASADigitalCardProtocols.swift
//  BASAMyPaymentsScreens
//
//  Created BranchbitG on 14/05/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol BASADigitalCardWireframeProtocol: class {

}
//MARK: Presenter -
protocol BASADigitalCardPresenterProtocol: class {
    func makeDigitalDataRequest(Body: Transaction,  DataCard: @escaping (DigitalCardResponse?) -> ())
}

//MARK: Interactor -
protocol BASADigitalCardInteractorProtocol: class {
  var presenter: BASADigitalCardPresenterProtocol?  { get set }
    func TryGetCardDigitalCardData(Body: Transaction,  DataCard: @escaping (DigitalCardResponse?) -> ())
}

//MARK: View -
protocol BASADigitalCardViewProtocol: class {

  var presenter: BASADigitalCardPresenterProtocol?  { get set }
}
