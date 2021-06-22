//
//  BASACardLimitsViewController.swift
//  GSSAFront
//
//  Created Desarrollo on 14/06/21.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import GSSAVisualComponents

class BASACardLimitsViewController: UIViewController, BASACardLimitsViewProtocol {
    
    var presenter: BASACardLimitsPresenterProtocol?
    
    @IBOutlet weak var table: UITableView!
    
    var cellSize = CGFloat(84.0)
    
    
    struct LimitItem{
        var title: String
        var subtitle: String
        var height: CGFloat
    }
    var LimitItems: Array<LimitItem> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LimitItems.append(LimitItem(title: "Retiro en cajero", subtitle: "Hasta $7,500.00", height: 84.0))
        LimitItems.append(LimitItem(title: "Límite de compra", subtitle: "Hasta $999,999,999.00", height: 84.0))
        
        registerCells()
        table.delegate = self
        table.dataSource = self
        table.alwaysBounceVertical = false
        NotificationCenter.default.addObserver(self, selector: #selector(handleFinishEditAction), name: NSNotification.Name(rawValue: "BASALimitCellEditFinished"), object: nil)
    }
    
    func registerCells(){
        table.register(UINib(nibName: "BASACardLimitCell", bundle: Bundle.init(for: BASACardLimitsViewController.self)), forCellReuseIdentifier: "BASACardLimitCell")
    }
    
    @objc func handleEditAction(sender: UIButton){
        table.beginUpdates()
        LimitItems[sender.tag].height = 130.0
        table.endUpdates()
    }
    
    @objc func handleFinishEditAction(){
        GSVCLoader.show(type: .native)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in
            GSVCLoader.hide()
            table.beginUpdates()
            for n in 0..<LimitItems.count{
                LimitItems[n].height = 84.0
            }
            table.endUpdates()
        })
    }
    
    @IBAction func close(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension BASACardLimitsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LimitItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "BASACardLimitCell") as! BASACardLimitCell
        cell.btnEdit.tag = indexPath.row
        cell.lblTitle.text = LimitItems[indexPath.row].title
        cell.lblSubtitle.text = LimitItems[indexPath.row].subtitle
        cell.btnEdit.addTarget(self, action: #selector(handleEditAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LimitItems[indexPath.row].height
    }
    
}
