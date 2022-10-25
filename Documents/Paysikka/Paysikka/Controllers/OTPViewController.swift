//
//  OTPViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 22/06/22.
//

import UIKit
import SwiftMessages


class OTPViewController: UIViewController, UITextFieldDelegate {
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBOutlet weak var OTPDropShadow: UIView!
    
    @IBOutlet weak var firstfield: UITextField!
    
    @IBOutlet weak var secondfield: UITextField!
    
    @IBOutlet weak var thirdfield: UITextField!
    
    @IBOutlet weak var fourthfield: UITextField!
    
    @IBOutlet weak var fifthfield: UITextField!
    
    @IBOutlet weak var sixthfield: UITextField!
    
    var mobile_num:String = ""
    var gtoken:String = ""
    var accesToken:String = ""
    // let page_name:String = ""
    
    var stotp1:String?
    var stotp2:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTPDropShadow.addShadow(offset: CGSize.zero, color: .lightGray, radius: 5, opacity: 2)
        
        firstfield.isUserInteractionEnabled = true
        firstfield.becomeFirstResponder()
        
        [firstfield,secondfield,thirdfield,fourthfield,fifthfield,sixthfield].forEach { textfield in
            
            textfield.delegate = self
            
        }
        
        firstfield.keyboardType = .numberPad
        secondfield.keyboardType = .numberPad
        thirdfield.keyboardType = .numberPad
        fourthfield.keyboardType = .numberPad
        fifthfield.keyboardType = .numberPad
        sixthfield.keyboardType = .numberPad

        firstfield.layer.borderColor = UIColor.black.cgColor
        secondfield.layer.borderColor = UIColor.black.cgColor
        thirdfield.layer.borderColor = UIColor.black.cgColor
        fourthfield.layer.borderColor = UIColor.black.cgColor
        fifthfield.layer.borderColor = UIColor.black.cgColor
        sixthfield.layer.borderColor = UIColor.black.cgColor
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            
            if textField == firstfield {
                secondfield.becomeFirstResponder()
            }
            
            if textField == secondfield {
                
                thirdfield.becomeFirstResponder()
            }
            
            if textField == thirdfield {
                
                fourthfield.becomeFirstResponder()
            }
            
            if textField == fourthfield {
                
                fifthfield.becomeFirstResponder()
            }
            if textField == fifthfield {
                sixthfield.becomeFirstResponder()
            }
            if textField == sixthfield {
                sixthfield.resignFirstResponder()
            }
            
            textField.text = string
            return false
            
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == secondfield {
                firstfield.becomeFirstResponder()
            }
            if textField == thirdfield {
                secondfield.becomeFirstResponder()
            }
            if textField == fourthfield {
                thirdfield.becomeFirstResponder()
            }
            if textField == fifthfield {
                fourthfield.becomeFirstResponder()
            }
            if textField == sixthfield {
                fifthfield.becomeFirstResponder()
            }
            if textField == firstfield {
                firstfield.resignFirstResponder()
            }
            
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        
        return true
    }
    
    @IBAction func validate_OTP(_ sender: Any) {
        
        stotp1 = "\(firstfield.text ?? "")\(secondfield.text ?? "")\(thirdfield.text ?? "")"
        stotp2 = "\(fourthfield.text ?? "")\(fifthfield.text ?? "")\(sixthfield.text ?? "")"
        
        let otp1 = stotp1 ?? ""
        let otp2 = stotp2 ?? ""
        let Full_OTP = otp1+otp2
        
        print("Full_OTP ",Full_OTP)
        
        if Full_OTP == " " {
            
            SwiftMessages.show {
                
                let view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureTheme(.error)
                
                view.configureContent(body: "Please enter OTP")
                
                view.button?.isHidden = true
                view.titleLabel?.isHidden = true
                
                return view
                
            }
            
        }else if Full_OTP.count < 6 {
            
            SwiftMessages.show {
                
                let view = MessageView.viewFromNib(layout: .cardView)
                
                view.configureTheme(.error)
                
                view.configureContent(body: "All Fields are required")
                
                view.button?.isHidden = true
                view.titleLabel?.isHidden = true
                
                return view
                
            }
            
        } else {
            print("Entered OTP ",Full_OTP)
            Verify_OTP_call(OTP: Full_OTP, gsToken: gtoken)
        }
        
    }
    
    @IBAction func resend_otp(_ sender: Any) {
        
        resend_OTP_Called(mobile: mobile_num)
        
    }
    
}

extension OTPViewController {
    
    func resend_OTP_Called(mobile:String) {
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/otp/91\(mobile)"
        
        guard let resendOtp = URL(string:fullurl) else {return}
        
        print("phone ",resendOtp)
        
        var url = URLRequest(url: resendOtp)
        url.httpMethod = "POST"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print("OTP StatusCode ",httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["messsage"] as? String ?? ""
                        
                        SwiftMessages.show {
                            
                            let view = MessageView.viewFromNib(layout: .cardView)
                            
                            view.configureTheme(.success)
                            
                            view.configureContent(body: msg)
                            
                            view.button?.isHidden = true
                            view.titleLabel?.isHidden = true
                            
                            return view
                            
                        }
                        
                        
                        print("success from Re-send OTP",recieved)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["message"] as? String
                        
                        print(recieved["message"] as Any)
                        
                        DispatchQueue.main.async {
                            
                            let alert = UIAlertController(title: "PaySikka", message: msg, preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .default)
                            
                            alert.addAction(action)
                            
                            self.present(alert, animated: true)
                            
                        }
                        
                        print("failure ",recieved)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
        
    }
    
    func Verify_OTP_call(OTP:String,gsToken:String) {
        
        LoadingOverlay.shared.showOverlay()
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/verifyotp"
        print("Verify_OTP_call: ",fullurl)
        guard let VerifyOTP = URL(string: fullurl) else {return}
        print("url",VerifyOTP)
        
        let dict = ["token":gsToken,"otp":OTP]
        
        print("params ",dict)
        
        let jsondata = try? JSONSerialization.data(withJSONObject: dict, options:.fragmentsAllowed)
        
        print("jsondata ",jsondata as Any)
        
         let auth = accesToken
        
        print("Auth Token ",auth)
        
        var url = URLRequest(url: VerifyOTP)
        url.httpMethod = "POST"
        url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        url.allHTTPHeaderFields = ["Authorization":auth]
        
        let dataTask = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, errorResponse in
            
           guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print("OTP StatusCode ",httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("success ",recieved)
                        
                        LoadingOverlay.shared.hideOverlayView()
                        
                        DispatchQueue.main.async { [self] in
                            
                            let NewHome:PaysikkaTabBar = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "PaysikkaTabBar") as! PaysikkaTabBar
                            NewHome.modalPresentationStyle = .fullScreen
                            self.present(NewHome, animated: true)
                            
                            let nav = self.navigationController
                            print(nav as Any)
                            
                            UserDefaults.standard.set(true, forKey: "userLoginState")
                            UserDefaults.standard.set(accesToken, forKey: "accessToken")
                            
                        }
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        guard let msg = recieved["message"] as? String else {return}
                        
                        print(recieved["message"] as Any)
                        
                        LoadingOverlay.shared.hideOverlayView()
                        
                        SwiftMessages.show {
                            
                            let view = MessageView.viewFromNib(layout: .cardView)
                            
                            view.configureTheme(.error)
                            
                            view.configureContent(body: msg)
                            
                            view.button?.isHidden = true
                            view.titleLabel?.isHidden = true
                            
                            return view
                            
                        }
                        
                        print("error from verify otp  ",recieved)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    let msg = "Techinal Problem, Please Try Again"
                    SwiftMessages.show {
                        
                        let view = MessageView.viewFromNib(layout: .cardView)
                        
                        view.configureTheme(.error)
                        
                        view.configureContent(body: msg)
                        
                        view.button?.isHidden = true
                        view.titleLabel?.isHidden = true
                        
                        return view
                        
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
        
    }
    
}
