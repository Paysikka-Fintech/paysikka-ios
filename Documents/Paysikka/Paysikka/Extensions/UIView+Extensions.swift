//
//  UIView+Extensions.swift
//  iOS-Project-Setup
//
//  Created by Shankar on 23/07/20.
//  Copyright © 2020 Shankar. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        
            layer.masksToBounds = false
            layer.shadowOffset = offset
            layer.shadowColor = color.cgColor
            layer.shadowRadius = radius
            layer.shadowOpacity = opacity
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        
            let backgroundCGColor = backgroundColor?.cgColor
            backgroundColor = nil
            layer.backgroundColor =  backgroundCGColor
        
        
        }
    
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//           let mask = CAShapeLayer()
//           mask.path = path.cgPath
//           layer.mask = mask
//           layer.shouldRasterize = true
//       }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
            if #available(iOS 11, *) {
                var cornerMask = CACornerMask()
                if(corners.contains(.topLeft)){
                    cornerMask.insert(.layerMinXMinYCorner)
                }
                if(corners.contains(.topRight)){
                    cornerMask.insert(.layerMaxXMinYCorner)
                }
                if(corners.contains(.bottomLeft)){
                    cornerMask.insert(.layerMinXMaxYCorner)
                }
                if(corners.contains(.bottomRight)){
                    cornerMask.insert(.layerMaxXMaxYCorner)
                }
                self.layer.cornerRadius = radius
                self.layer.maskedCorners = cornerMask

            } else {
                let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                self.layer.mask = mask
            }
        }
    

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func removeShadow() {
        layer.shadowOffset = CGSize(width: 0 , height: 0)
        layer.shadowColor = UIColor.clear.cgColor
        layer.shadowRadius = 0.0
        layer.shadowOpacity = 0.00
    }
    
    func hide() {
        isHidden = true
    }
    
    func show() {
        isHidden = false
    }
    
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.3,
                       initialSpringVelocity: 0.1,
                       options: UIView.AnimationOptions.beginFromCurrentState,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func setGradientBackgroundColor(_ Colors:[Any],_ Angle:GradientPoint){
        let layer = CAGradientLayer()
        layer.name = "gradient"
        layer.colors = Colors
        layer.frame = self.bounds
        gradientPoint(Angle, layer)
        self.layer.insertSublayer(layer, at: 0)
    }
    private func gradientPoint(_ Point:GradientPoint, _ layer:CAGradientLayer) {
        switch Point {
        case .LeftToRight:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
            break
        case .ToptoButtom:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 0, y: 1)
            break
        case .TopLeftToButtomRight:
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 1)
            break
        case .TopRightToButtomLeft:
            layer.startPoint = CGPoint(x: 1, y: 1)
            layer.endPoint = CGPoint(x: 0, y: 0)
            break
        case .BottomLeftToTopRight:
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 1, y: 0)
            break
        }
    }
    
    func dismissSlowly(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.hide()
        }
    }
    
    func presentSlowly(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.show()
        }
    }
    
    enum GradientPoint {
        case LeftToRight
        case ToptoButtom
        case TopLeftToButtomRight //135 degree
        case TopRightToButtomLeft //315 degree
        case BottomLeftToTopRight //45 degree
    }
}

extension UIViewController {
    
    func  backButton(title:String){
        
        self.tabBarController?.tabBar.isHidden = true
        print("which page ",title)
        
//        if title == "Home" || title == "Transactions"{
//        self.tabBarController?.tabBar.isHidden = false
//
//        }else{
//        self.tabBarController?.tabBar.isHidden = true
//        }
        
        let backButton = UIBarButtonItem(image: UIImage(named: "Paysikka-100"), style: .plain, target:nil, action: nil)
        backButton.image = backButton.image?.withRenderingMode(.alwaysOriginal)
        backButton.width = 40
        
        var IDLbl:UILabel!
        //var pageNameLbl:UILabel!
        
        let preferences = UserDefaults.standard
        
        IDLbl = UILabel()
        IDLbl.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        let name = preferences.string(forKey: "username") ?? ""
        let id = "PS- \(preferences.string(forKey: "userid") ?? "")"
        
        print("RightBar Button:",name + id)
        IDLbl.font = UIFont(name: "HelveticaNeue", size: 15)
        IDLbl.text = name + "\n" + id
      //  IDLbl.tintColor = UIColor(named: "GoldText")
        IDLbl.numberOfLines = 2
        IDLbl.adjustsFontSizeToFitWidth = true
        
        switch title {
        case "Log In":
            IDLbl.text = ""
        case "Sign in":
            IDLbl.text = ""
        case "Sign up":
            IDLbl.text = ""
        case "OTP":
            IDLbl.text = ""
        case "Home":
            IDLbl.text = ""
            
        default:
            IDLbl.text = name + "\n" + id
            
        }
        
        var titileFont = UIFont(name: "HelveticaNeue", size: 15)
        titileFont = .boldSystemFont(ofSize: 15)
        
        let attributes = [NSAttributedString.Key.font:titileFont]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        self.navigationItem.title = title
    
        let rightbarbutton = UIBarButtonItem(customView:IDLbl)
        
        self.navigationItem.rightBarButtonItem = rightbarbutton
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton;
        navigationController?.navigationBar.barTintColor = UIColor.init(named: "white")
        
    }
    
}

extension UITextField {

    func textfieldAddShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
            layer.masksToBounds = false
            layer.shadowOffset = offset
            layer.shadowColor = color.cgColor
            layer.shadowRadius = radius
            layer.shadowOpacity = opacity

            let backgroundCGColor = backgroundColor?.cgColor
            backgroundColor = nil
            layer.backgroundColor =  backgroundCGColor
        }
    
    func addImagetoTextField(){
        let img = UIImage(named: "rupee")
        let  leftImageView = UIImageView(frame:CGRect(x:10, y: 0.0, width:img!.size.width+20, height:img!.size.height+20))
        leftImageView.contentMode = .scaleAspectFit
        leftImageView.image = img
        self.leftView = leftImageView
        self.textAlignment = .left
        self.leftViewMode = .always
       
    }
    
}
/*
@IBDesignable extension UITextField {
    
    @IBInspectable var TextFieldBorderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
  
}*/


extension UIColor {
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIView {
    
    
    func origin() -> CGPoint {
        return frame.origin
    }
    
    func setOrigin(_ newOrigin: CGPoint) {
        var newFrame: CGRect = frame
        newFrame.origin = newOrigin
        frame = newFrame
    }
    
    func size() -> CGSize {
        return frame.size
    }
    
    func setSize(_ newSize: CGSize) {
        var newFrame: CGRect = frame
        newFrame.size = newSize
        frame = newFrame
    }
    func x() -> CGFloat {
        return frame.origin.x
    }
    
    func setX(_ newX: CGFloat) {
        var newFrame: CGRect = frame
        newFrame.origin.x = newX
        frame = newFrame
    }
    
    func y() -> CGFloat {
        return frame.origin.y
    }
    
    func setY(_ newY: CGFloat) {
        var newFrame: CGRect = frame
        newFrame.origin.y = newY
        frame = newFrame
    }
    
    func height() -> CGFloat {
        return frame.height
    }
    
    func setHeight(_ newHeight: CGFloat) {
        var newFrame: CGRect = frame
        newFrame.size.height = newHeight
        frame = newFrame
    }
    
    func width() -> CGFloat {
        return frame.size.width
    }
    
    func setWidth(_ newWidth: CGFloat) {
        var newFrame: CGRect = frame
        newFrame.size.width = newWidth
        frame = newFrame
    }
    
    func maxx() -> CGFloat {
        return frame.maxX
    }
    
    func maxy() -> CGFloat {
        return frame.maxY
    }
    func minx() -> CGFloat {
        return frame.minX
    }
    
    func miny() -> CGFloat {
        return frame.minY
    }
    
    func vheight() -> CGFloat {
        return frame.height
    }
    
    func vWidth() -> CGFloat {
        return frame.width
    }
}

/*
@IBDesignable extension UIView {
    
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.cgColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
}*/

