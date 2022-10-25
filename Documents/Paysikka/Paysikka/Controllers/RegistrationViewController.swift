//
//  RegistrationViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 22/06/22.
//

import UIKit
import Alamofire
import SwiftMessages
import AudioToolbox

class RegistrationViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var registerDropShadow: UIView!
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var phonenumber: UITextField!
    
    @IBOutlet weak var username: UITextField!
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBAction func siginTapped(_ sender: Any) {
        
        let login:LoginViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        login.modalPresentationStyle = .fullScreen
        self.present(login, animated: true)
        
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        return .portrait
        
    }
    
    var registerData:[RegistrationModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phonenumber.delegate = self
        
        registerDropShadow.addShadow(offset: CGSize.zero, color:.lightGray, radius: 5, opacity:2)
        
        userEmail.textfieldAddShadow(offset: CGSize.zero, color: .lightGray, radius: 5, opacity: 2)
        
        phonenumber.textfieldAddShadow(offset: CGSize.zero, color: .lightGray, radius: 5, opacity: 2)
        
        username.textfieldAddShadow(offset: CGSize.zero, color: .lightGray, radius: 5, opacity: 2)
        
        //  setupToolbar()
        
        username.textContentType = .username
        userEmail.keyboardType = .emailAddress
        userEmail.textContentType = .emailAddress
        phonenumber.keyboardType = .phonePad
        phonenumber.textContentType = .telephoneNumber
        
    }
    
    @objc func dismissMyKeyboard() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        view.frame.origin.y = -170 // Move view 170 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        view.frame.origin.y = 0 // Move view to original position
    }
    
    
    @IBAction func signupBtnCalled(_ sender: Any) {
        
        guard let phonenum = phonenumber.text else {return}
        guard let email = userEmail.text else {return}
        guard let username = username.text else {return}
        
        print("phone_Num: ",phonenum)
        
        print("isValidContact: ",phonenum.isValidContact)
        
        if phonenum.count == 0 {
            
            let alert = UIAlertController(title: "PaySikka", message: "Mobile Number is required", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }else if userEmail.text == "" {
            
            let alert = UIAlertController(title: "PaySikka", message: "Email is required", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }
        
        if phonenum.isValidContact && email.isValidEmail(email) && !username.isEmpty {
            
              signup_api_call(email: email, mobile: phonenum, username: username)
            
        }else {
            
            let alert = UIAlertController(title: "PaySikka", message: "Please Enter Your Name", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
            
        }
        
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("textFieldDidEndEditing ",reason.rawValue)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if !textField.text!.isValidContact {
            
            let alert = UIAlertController(title: "PaySikka", message: "Entered Mobile Number is invalid", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        }else if !textField.text!.isValidEmail(textField.text!){
            let alert = UIAlertController(title: "PaySikka", message: "Entered Email is invalid", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString

            if newString.length == maxLength {
                textField.text = textField.text! + string
                textField.resignFirstResponder()
            }

            return newString.length <= maxLength
    }
        
        
        
        func setupToolbar() {
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
            //Create a toolbar
            let bar = UIToolbar()
            
            //Create a done button with an action to trigger our function to dismiss the keyboard
            let doneBtn = UIBarButtonItem(title: "Done", style:.done, target: self, action: #selector(dismissMyKeyboard))
            
            //Create a felxible space item so that we can add it around in toolbar to position our done button
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            //Add the created button items in the toobar
            bar.items = [flexSpace, flexSpace, doneBtn]
            bar.sizeToFit()
            
            //Add the toolbar to our textfield
            phonenumber.inputAccessoryView = bar
            userEmail.inputAccessoryView = bar
        }
        
        
        func signup_api_call(email:String,mobile:String,username:String) {
            
            LoadingOverlay.shared.showOverlay()
            
            let baseUrl = APIConstants.BaseURL
            let fullurl = baseUrl+"auth/register"
            guard let signupurl = URL(string: fullurl) else {return}
            let email = email
            let emailSplit = email
            let username = emailSplit.split(separator: "@").first
            guard let userstring = username as? NSString else {return}
            
            let postParameters = [
                "email": email,
                "phone": mobile,
                "via_registration": 2,
                "name": username
            ] as [String : Any]
            
            print("postParameters ",postParameters)
            
            let jsondata = try? JSONSerialization.data(withJSONObject: postParameters, options: .prettyPrinted)
            
            print("jsondata ",jsondata)
            
            var url = URLRequest(url: signupurl)
            url.httpMethod = "POST"
            url.httpBody = jsondata
            url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
                
                guard let data = dataResponse else {return}
                
                if let httpResponse = urlResponse as? HTTPURLResponse {
                    print(httpResponse.statusCode)
                    
                    if httpResponse.statusCode == 200 {
                        
                        do {
                            
                            let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                            
                            let register_Data = RegistrationModel(fromDictionary: recieved as? [String : Any] ?? ["":""])
                            
                            let gs_token = register_Data.user?.gsToken ?? ""
                            let accessToken = register_Data.accessToken ?? ""
                            let phone_num = register_Data.user?.phone ?? 0
                            
                            LoadingOverlay.shared.hideOverlayView()
                            
                            DispatchQueue.main.async {
                                
                                print("success ",recieved,gs_token,phone_num)
                                
                                let OTPViewcontroller:OTPViewController =
                                UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                OTPViewcontroller.mobile_num = "\(phone_num)"
                                OTPViewcontroller.gtoken = gs_token
                                OTPViewcontroller.accesToken = accessToken
                                OTPViewcontroller.modalPresentationStyle = .fullScreen
                                self.present(OTPViewcontroller, animated: true)
                                
                            }
                            
                        }catch{
                            print("there's a catch")
                        }
                        
                    }else if httpResponse.statusCode == 400 {
                        
                        do {
                            
                            let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                            
                            let msg = recieved["message"] as? String ?? ""
                            
                            LoadingOverlay.shared.hideOverlayView()
                            
                            print(recieved["message"])
                            
                            SwiftMessages.show {
                                
                                let view = MessageView.viewFromNib(layout: .cardView)
                                
                                view.configureTheme(.error)
                                
                                view.configureContent(body: msg)
                                
                                view.button?.isHidden = true
                                view.titleLabel?.isHidden = true
                                
                                return view
                                
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
        
    }
