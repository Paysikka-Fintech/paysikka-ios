//
//  String+Extensions.swift
//  Paysikka
//
//  Created by George Praneeth on 08/07/22.
//

import Foundation
import UIKit

extension String {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var isValidContact: Bool {
           let phoneNumberRegex = "^[6-9]\\d{9}$"
           let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
           let isValidPhone = phoneTest.evaluate(with: self)
           return isValidPhone
       }
    
}

extension UITextField{
    
    func addBottomBorderTo() {
        let layer = CALayer()
        layer.backgroundColor = UIColor.gray.cgColor
        layer.frame = CGRect(x: 0.0, y: self.frame.size.height, width: self.frame.size.width-4, height: 2.0)
        self.layer.addSublayer(layer)
    }
    
}
