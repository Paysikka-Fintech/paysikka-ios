//
//  UITextfield+Extensions.swift
//  Paysikka
//
//  Created by George Praneeth on 12/07/22.
//

import Foundation
import UIKit

extension UITextField {
    
    func addImagetoTextField(name:String){
        let img = UIImage(named:name)
        let  leftImageView = UIImageView(frame:CGRect(x:10, y: 0.0, width:img!.size.width+20, height:img!.size.height+20))
        leftImageView.contentMode = .scaleToFill
        leftImageView.image = img
        self.leftView = leftImageView
//        self.placeholder = "Enter Amount"
        self.textAlignment = .left
        self.leftViewMode = .always
        
    }
  
    func  addingAsterik(str:String){
         let  AttriburedString = NSMutableAttributedString(string:str)
         let asterix = NSAttributedString(string:"*", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
        AttriburedString.append(asterix)
         self.attributedPlaceholder = AttriburedString
    }
  
}


