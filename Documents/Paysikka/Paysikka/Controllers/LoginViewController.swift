//
//  LoginViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 21/06/22.
//

import UIKit
import SwiftMessages
import Alamofire
import AudioToolbox

class LoginViewController: UIViewController,UITextFieldDelegate {

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        
        return .portrait
        
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBOutlet weak var dropshadowView: UIView!
    
    @IBOutlet weak var phonenumber: UITextField!
    
    @IBOutlet weak var request_otp_Btn: UIButton!
    
    @IBOutlet weak var newuserBtn: UIButton!
    
    var globalaccesstoken:String!
    var globalphoneNumber:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phonenumber.delegate = self
        
      //  dropshadowView.dropShadow(color:.lightGray, opacity:0.5, offSet:CGSize(width:1, height: 1), radius: 2, scale: true)
        
       // backButton(title: "Login")
        
        phonenumber.keyboardType = .numberPad
        phonenumber.textContentType = .telephoneNumber
        
        dropshadowView.addShadow(offset: CGSize.zero, color:.lightGray, radius: 5, opacity:2)
        
        phonenumber.textfieldAddShadow(offset: CGSize.zero, color: .lightGray, radius: 5, opacity: 2)
        
        request_otp_Btn.addTarget(self, action: #selector(login_Func_Called), for: .touchUpInside)
        
        newuserBtn.addTarget(self, action: #selector(new_user_tapped), for: .touchUpInside)

    
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        let currentText = textField.text ?? ""
//        // attempt to read the range they are trying to change, or exit if we can't
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        // add their new text to the existing text
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string) as NSString
//
//        if updatedText.length == 10{
//            textField.resignFirstResponder()
//            return false
//        }else {
//            return true
//
//        }
        
        let maxLength = 10
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        
        if newString.length == maxLength {
            textField.text = textField.text! + string
            textField.resignFirstResponder()
        }
        
        return newString.length <= maxLength
        
    }
    
    
    @objc func login_Func_Called() {
        
        guard let phonenum = phonenumber.text else {return}
        
        if phonenum.isValidContact {
            
           loginApi()
            
        }else {
            
            let alert = UIAlertController(title: "Paysikka", message: "Invalid Number", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            
            self.present(alert, animated: true)
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        
    }
    
    func loginApi() {
        /*
         guard let phonenum = phonenumber.text else { return }
         
         print("phone ",phonenum)
         
         let dict = ["phone":phonenum]
         
         print("params ",dict)
         
         do{
         
         let request = try APIRequest(method: .post, path: "auth/login",body:dict)
         APIClient().perform(request) { (result) in
         
         switch result {
         
         case .success(let response):
         print("Sucess from Login: ",response.body)
         let result = response.body
         
         case .failure(let error):
         print("Error from Login: ",error.localizedDescription)
         
         }
         
         }
         }catch{
         
         print("Can't Hit LoginApi")
         }*/
        
        LoadingOverlay.shared.showOverlay()
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"auth/login"
        guard let loginurl = URL(string:fullurl) else { return }
        guard let phonenum = phonenumber.text else { return }
        
        print("phone ",phonenum)
        
        let dict = ["phone":phonenum]
        
        print("params ",dict)
        
        let jsondata = try? JSONSerialization.data(withJSONObject: dict, options:.fragmentsAllowed)
        
        print("jsondata ",jsondata)
        
        var url = URLRequest(url: loginurl)
        url.httpMethod = "POST"
        url.httpBody = jsondata
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                
                if httpResponse.statusCode == 200 {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("success from login_api ",recieved)
                        
                        let checkuser =  recieved["checkuser"] as! NSDictionary
                        let accessToken = recieved["accessToken"] as! String
                        let phonenumber = checkuser["phone"] as! Int
                        let gtoken = checkuser["gs_token"] as? String ?? ""
                        let username = checkuser["name"] as? String
                        let userid = checkuser["userid"] as? Int
                        globalaccesstoken = accessToken
                        globalphoneNumber = phonenumber
                        
                        UserDefaults.standard.set(username, forKey: "username")
                        UserDefaults.standard.set(userid, forKey: "userid")
                    
                        if !gtoken.isEmpty {
                            send_OTP_api_call(mobile:phonenum)
                            DispatchQueue.main.async {
                                let OTPViewcontroller:OTPViewController =
                                self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                OTPViewcontroller.mobile_num = "\(phonenumber)"
                                OTPViewcontroller.gtoken = gtoken
                                OTPViewcontroller.accesToken = accessToken
                                OTPViewcontroller.modalPresentationStyle = .fullScreen
                                self.present(OTPViewcontroller, animated: true)
                                
                            }
                            
                        }else{
                            print("Calling GS-User")
                            checkGSUser()
                        }
                        
                    }
                    catch {
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
                    
                }else if httpResponse.statusCode == 403 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        guard let msg = recieved["message"] as? String else {return}
                        
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
                        
                        print("failure 403 from Login ",recieved)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
        
    }
    
    
    func checkGSUser() {
        
        LoadingOverlay.shared.showOverlay()
        
        let int_to_String = String(globalphoneNumber)
        print("Check GSUserNum: ",int_to_String)
        let requrl = URL(string: "https://staging-api.dev.goldsikka.in/api/paysikka/checkuser/91\(int_to_String)")
        guard let urlReq = try? URLRequest(url: requrl!, method: .post) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: urlReq) { dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("success from login_api ",recieved)
                        
                        let token = recieved["token"] as? String
                        
                        DispatchQueue.main.async { [self] in
                            
                            let OTPViewcontroller:OTPViewController =
                            self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                            OTPViewcontroller.mobile_num = "\(String(describing: globalphoneNumber))"
                            OTPViewcontroller.gtoken = token ?? ""
                            OTPViewcontroller.accesToken = globalaccesstoken
                            OTPViewcontroller.modalPresentationStyle = .fullScreen
                            self.present(OTPViewcontroller, animated: true)
                            
                        }
                        
                    
                    }
                    catch {
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
                    
                }else if httpResponse.statusCode == 403 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        guard let msg = recieved["message"] as? String else {return}
                        
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
                        
                        print("failure 403 from Login ",recieved)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                   
                }else {
                    
                    
                }
                
            }
            
        }
        dataTask.resume()
        
    }
    
    func send_OTP_api_call(mobile:String) {
        
        print(#function)
        
        let baseUrl = APIConstants.BaseURL
        let fullurl = baseUrl+"user/otp/91\(mobile)"
        
        guard let sendOtp = URL(string:fullurl) else {return}
        
        var url = URLRequest(url: sendOtp)
        url.httpMethod = "POST"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["messsage"] as? String ?? ""
                        
                        print("success ",recieved)
                        
                        SwiftMessages.show {
                            
                            let view = MessageView.viewFromNib(layout: .cardView)
                            
                            view.configureTheme(.success)
                            
                            view.configureContent(body: msg)
                            
                            view.button?.isHidden = true
                            view.titleLabel?.isHidden = true
                            
                            return view
                            
                        }
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }else if httpResponse.statusCode == 400 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["message"] as? String
                        
                        print(recieved["message"])
                        
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
                    
                }else if httpResponse.statusCode == 401 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        let msg = recieved["messsage"] as? String ?? ""
                        
                        print(recieved["message"],msg)
                        
                        
                        SwiftMessages.show {
                            
                            let view = MessageView.viewFromNib(layout: .cardView)
                            
                            view.configureTheme(.error)
                            
                            view.configureContent(body: msg)
                            
                            view.button?.isHidden = true
                            view.titleLabel?.isHidden = true
                            
                            return view
                            
                        }
                        
                        print("failure 401 from otp ",recieved)
                        
                    }
                    catch {
                        print("there's a catch")
                    }
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    @objc func new_user_tapped() {
        
        let Registration:RegistrationViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        Registration.modalPresentationStyle = .fullScreen
        self.present(Registration, animated: true)
        
    }
    
}
