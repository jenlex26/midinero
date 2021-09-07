//
//  GSSARockaletaCustom.swift
//  GSSAMyMoney
//
//  Created by Andoni Suarez on 05/08/21.
//

import Foundation
import UIKit
//
//  GSFRockaletaControl.swift
//  GSSAVisualComponents
//
//  Created by cemartinezga on 02/08/21.
//
public class GSFMoneyRockaletaControl: UIRefreshControl {
    
    var rock: UIImageView?
    private var isAnimating: Bool = false
    
    public override init() {
        super.init()
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addRockaleta() {
        let rocka = UIImageView(image: UIImage(named: "bazballSA"))
        rocka.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        rocka.backgroundColor = .clear
        self.subviews.first?.addSubview(rocka)
        rocka.center = rocka.superview?.center ?? .zero
        
        rock = rocka
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if let rock = rock,
           let containtView = rock.superview {
            if containtView.frame.height >= (rock.frame.height / 2) {
                containtView.alpha = 1
                if !isAnimating {
                    animateRockaleta()
                }
            } else {
                containtView.alpha = 0
                stopRockaleta()
            }
            rock.center = containtView.center
        } else {
            addRockaleta()
        }
    }
    
    public override func endRefreshing() {
        super.endRefreshing()
        stopRockaleta()
    }
    
    public override func beginRefreshing() {
        super.beginRefreshing()
        animateRockaleta()
    }
    
    private func animateRockaleta() {
        if let rock = rock {
            isAnimating = true
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    rock.transform = rock.transform.rotated(by: .pi)
                    rock.layoutIfNeeded()
                } completion: { _ in
                    self.animateRockaleta()
                }
            }
        }
    }
    
    private func stopRockaleta() {
        rock?.removeFromSuperview()
        rock = nil
        isAnimating = false
    }
}
