//
//  File.swift
//  BASAMyPayments
//
//  Created by Benigno Marin Mendoza on 03/06/21.
//

import Foundation

//MARK: Wireframe -
public protocol BASAScanCodeWireframeProtocol: AnyObject {
    func codeDetectedRouter(sCode: String)
    func cancelCodeScanner()

}
//MARK: Presenter -
protocol BASAScanCodePresenterProtocol: AnyObject {
    func codeDetected(sCode: String)
    func cancelCodeScanner()
}

//MARK: Interactor -
protocol BASAScanCodeInteractorProtocol: AnyObject {

  var presenter: BASAScanCodePresenterProtocol?  { get set }
}

//MARK: View -
protocol BASAScanCodeViewProtocol: AnyObject {

  var presenter: BASAScanCodePresenterProtocol?  { get set }
}
