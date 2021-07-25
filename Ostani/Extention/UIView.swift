//
//  UIView.swift
//  Ostani
//
//  Created by ali on 7/15/21.
//

import UIKit


extension UIView {
    
    func roundUp(_ value: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            self?.layer.cornerRadius = value
            self?.layer.masksToBounds = true
        }
    }
    
    func addBorder(cornerRadius: CGFloat, color: UIColor = .brandGreen , borderWidth : CGFloat = 3) {
        DispatchQueue.main.async { [weak self] in
            self?.roundUp(cornerRadius)
            self?.layer.borderWidth = borderWidth
            self?.layer.borderColor = color.cgColor
        }
    }
}
