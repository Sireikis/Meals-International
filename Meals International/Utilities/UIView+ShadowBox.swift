//
//  UIView+ShadowBox.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/15/21.
//

import Foundation
import UIKit


extension UIView {
    
    public func roundedBoxWithBorderAndShadow() {
        let view = self
        
        view.layer.masksToBounds = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 10.0
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowOpacity = 0.5
        
        view.layer.cornerRadius = view.frame.height / 2
    }
}
