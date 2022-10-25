//
//  ProfileViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 27/07/22.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController {

    var username:String = ""
    var userid:String = ""
    
    @IBOutlet weak var profilelistTBV: UITableView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userID: UILabel!
    
    let profilelist = ["","Terms and conditions","Privacy policy","Logout"]
    let profilelistimg = ["","privacy-policy","privacy-policy","logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("profile nav ",self.navigationController?.isNavigationBarHidden)
       // backButton(title: "Profile")
        self.navigationController?.isNavigationBarHidden = false
        profilelistTBV.delegate = self
        profilelistTBV.dataSource = self
        profilelistTBV.register(UINib(nibName: "ProfileListTableViewCell", bundle: nil), forCellReuseIdentifier: ProfileListTableViewCell.identifier)

        let user = UserDefaults.standard
        username = user.string(forKey: "username") ?? ""
        userid = user.string(forKey: "userid") ?? ""
        
        usernameLbl.text = "Username:   "+username
        userID.text = "UserID:   PS-"+userid
        
        usernameLbl.isHidden = false
        userID.isHidden = false
        
    }
    
    
//    @IBAction func logout(_ sender: Any) {
//
//        let alertcontrol = UIAlertController(title: "Paysikka", message: "Are You Sure You Want To Logout ?", preferredStyle: .alert)
//
//        let action = UIAlertAction(title: "Yes", style: .default){ [self] response in
//
//            UserDefaults.standard.set(false, forKey: "userLoginState")
//            let login:LoginViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            login.modalPresentationStyle = .fullScreen
//            self.present(login, animated: true)
//
//        }
//
//        let noaction = UIAlertAction(title: "NO", style: .destructive) { response in
//
//        }
//
//        alertcontrol.addAction(action)
//        alertcontrol.addAction(noaction)
//
//        self.present(alertcontrol, animated: true)
//
//    }
    
}

extension ProfileViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profilelist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:ProfileListTableViewCell.identifier, for: indexPath) as! ProfileListTableViewCell
        
        if indexPath.row == 0 {
            cell.listItemBtn.isHidden = true
        }else{
            cell.listItemBtn.setTitle(profilelist[indexPath.row], for: .normal)
            cell.listItemBtn.isUserInteractionEnabled = false
            cell.listItemBtn.setImage(UIImage(named: profilelistimg[indexPath.row]), for: .normal)
            cell.listItemBtn.imageEdgeInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
            cell.listItemBtn.imageView?.tintColor = UIColor.init(named: "AppColor")
        }
        
//        if cell.listItemBtn.titleLabel?.text == profilelist[1]{
//           cell.listItemBtn.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward"), for: .normal)
//        }else{
//            cell.listItemBtn.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.forward"), for: .normal)
//         //  cell.listItemBtn.setImage(UIImage(named: "verify-account"), for: .normal)
//        }
        
        
        return cell
        
        
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellTitle = tableView.cellForRow(at: indexPath) as! ProfileListTableViewCell
        
        
        if cellTitle.listItemBtn.titleLabel?.text == profilelist[0]{
            
        
        }else if cellTitle.listItemBtn.titleLabel?.text == profilelist[1]{
            
            let webcontent = SFSafariViewController(url: URL(string: "https://demo.paysikka.com/terms.php")!)
            self.present(webcontent, animated: true)
        }else if cellTitle.listItemBtn.titleLabel?.text == profilelist[2]{
            let webcontent = SFSafariViewController(url: URL(string: "https://demo.paysikka.com/privacypolicy.php")!)
            self.present(webcontent, animated: true)
        
        }else if cellTitle.listItemBtn.titleLabel?.text == profilelist[3]{
            
            let alertcontrol = UIAlertController(title: "Paysikka", message: "Are You Sure You Want To Logout ?", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Yes", style: .default){ [self] response in
                
                UserDefaults.standard.set(false, forKey: "userLoginState")
                let login:LoginViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                login.modalPresentationStyle = .fullScreen
                self.present(login, animated: true)
                
            }
            
            let noaction = UIAlertAction(title: "NO", style: .destructive) { response in
                
            }
            
            alertcontrol.addAction(action)
            alertcontrol.addAction(noaction)
            
            self.present(alertcontrol, animated: true)
            
        }else if cellTitle.listItemBtn.titleLabel?.text == profilelist[0]{
           
            let KYC:KYCViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
            self.navigationController?.pushViewController(KYC, animated: true)
           
        }
        
        
    }
          
    
    
    
    
    
}
