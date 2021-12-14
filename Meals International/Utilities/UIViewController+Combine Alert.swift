//
//  UIViewController+Combine Alert.swift
//  Meals International
//
//  Created by Ignas Sireikis on 12/13/21.
//

import UIKit
import Combine


extension UIViewController {
    
    public func alert(title: String, text: String?) -> AnyPublisher<Void, Never> {
        let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
        
        return Future { resolve in
            alertVC.addAction(UIAlertAction(title: "Close", style: .default) { _ in
                resolve(.success(()))
            })
            
            self.present(alertVC, animated: true, completion: nil)
        }
        .handleEvents(receiveCancel: {
            self.dismiss(animated: true)
        })
        .eraseToAnyPublisher()
    }
}
