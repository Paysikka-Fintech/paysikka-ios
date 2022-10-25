//
//  NewHomeViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 13/07/22.
//

import UIKit
import AVKit
import SwiftUI

class NewHomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
        
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        
        return UIInterfaceOrientation.portrait
        
    }
    
    @IBOutlet weak var bannersCV: UICollectionView!

    @IBOutlet weak var goldvaultShadow: UIView!
    
    @IBOutlet weak var downdropshadow: UIView!
    
    @IBOutlet weak var goldgrams: UILabel!
    
    @IBOutlet weak var buygoldBtn: UIButton!
    
    @IBOutlet weak var redeemgoldBtn: UIButton!
    
    @IBOutlet weak var scanQRcode: UIButton!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    @IBOutlet weak var scanQRCodeView: UIView!

    @IBOutlet weak var pagecontrol: UIPageControl!
    
    var banner_Images:[String] = []
    
    var imageSize = CGSize()
    
    var screenWidth = UIScreen.main.bounds.width
    
    var currentIndex = 0
    var timer : Timer?
    
    var globalGoldBalance:String = ""
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let ipaddress:String = getIPAddress()
//        print("ipaddress ",ipaddress)

          

        backButton(title: "Home")
        self.tabBarController?.tabBar.isHidden = false
        
        let bar = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(pushtoProfile))
        
        self.navigationItem.rightBarButtonItem = bar
        
        view.bringSubviewToFront(pagecontrol)
        
        pagecontrol.numberOfPages = banner_Images.count
        
        print("the hello",banner_Images.count)
        print("page_opaque ",pagecontrol.isOpaque)
        
     //   goldvaultShadow.roundCorners(corners: .allCorners, radius:1)
      //  downdropshadow.roundCorners(corners:.allCorners, radius: 1)
      //  scanQRCodeView.roundCorners(corners: .allCorners, radius:1)
        
        //goldvaultShadow.addShadow(offset: CGSize.zero, color:.white, radius: 2, opacity:1)
        
        //downdropshadow.addShadow(offset: CGSize.zero, color:.white, radius: 2, opacity:1)
        
        //scanQRCodeView.addShadow(offset: CGSize.zero, color:.white, radius: 2, opacity:1)
        
        goldvaultShadow.backgroundColor = .white
        downdropshadow.backgroundColor = .white
        scanQRCodeView.backgroundColor = .white
        
        scanQRCodeView.layer.shadowColor = UIColor.white.cgColor
        scanQRCodeView.layer.shadowOffset = CGSize(width: 5, height: 5)
        scanQRCodeView.layer.shadowRadius = 5
        scanQRCodeView.layer.shadowOpacity = 1.0
        scanQRCodeView.layer.shouldRasterize = true
        scanQRCodeView.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        buygoldBtn.layer.shadowColor = UIColor.white.cgColor
        buygoldBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        buygoldBtn.layer.shadowRadius = 5
        buygoldBtn.layer.shadowOpacity = 1.0
        buygoldBtn.layer.shouldRasterize = true
        buygoldBtn.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        redeemgoldBtn.layer.shadowColor = UIColor.white.cgColor
        redeemgoldBtn.layer.shadowOffset = CGSize(width: 5, height: 5)
        redeemgoldBtn.layer.shadowRadius = 5
        redeemgoldBtn.layer.shadowOpacity = 1.0
        redeemgoldBtn.layer.shouldRasterize = true
        redeemgoldBtn.layer.rasterizationScale = true ? UIScreen.main.scale : 1
        
        call_Banners()
        flowBannerLayout()
        getGramsBalance()
        
        buygoldBtn.addTarget(self, action: #selector(buyGoldTapped), for: .touchUpInside)
        redeemgoldBtn.addTarget(self, action: #selector(redeemGoldTapped), for: .touchUpInside)
        scanQRcode.addTarget(self, action: #selector(scanQRCodeTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(scanQRCodeTapped))
        scanQRCodeView.addGestureRecognizer(tapGesture)
        
    }
    
    func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) {
                    
                    //ipv6 = || addrFamily == UInt8(AF_INET6)
                    // wifi = ["en0"]
                   //  wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                    
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    
    func startTimer(){
    
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(){
        
        let desiredScrollPosition = (currentIndex < banner_Images.count - 1) ? currentIndex + 1 : 0
        bannersCV.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @objc func buyGoldTapped() {
        
        let buygold:BuyGold = UIStoryboard(name: "BuyGold", bundle: nil).instantiateViewController(withIdentifier: "Buy_Gold") as! BuyGold
        buygold.modalPresentationStyle = .automatic
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(buygold, animated: true)
        
    }
    
    @objc func redeemGoldTapped() {
        
        let redeem : RedeemViewController = UIStoryboard(name: "Redeem", bundle: nil).instantiateViewController(withIdentifier: "Redeem") as! RedeemViewController
        redeem.modalPresentationStyle = .automatic
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(redeem, animated: true)
        
    }
    
    @objc func scanQRCodeTapped() {
        
        let scanner = QRCodeScannerController()
        scanner.delegate = self
        scanner.qrScannerConfiguration.readQRFromPhotos = true
        scanner.qrScannerConfiguration = .default
        
        scanner.modalPresentationStyle = .automatic
        
        DispatchQueue.main.async { [self] in
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(scanner, animated: true)
            
        }
        
    }
    
    
    @objc func pushtoProfile(){
        
        let profile: ProfileViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileVC") as! ProfileViewController
     //   profile.userid =
      //  profile.username =
        
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(profile, animated: true)
        
    }
    
    
    func flowBannerLayout(){
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:screenWidth/1, height:300)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top:2, left:0, bottom:2, right:0)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        bannersCV.collectionViewLayout = layout
        bannersCV.showsHorizontalScrollIndicator = false
        bannersCV.showsVerticalScrollIndicator = false
        bannersCV.delegate = self
        bannersCV.dataSource = self
        
      }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        pagecontrol.numberOfPages = banner_Images.count
        return banner_Images.count
        
        /*
        if banner_Images.count == 0 {

            return 0

        }else{
            pagecontrol.numberOfPages = banner_Images.count
            return banner_Images.count
        }
         */
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = bannersCV.dequeueReusableCell(withReuseIdentifier: BannerCVCell.identifier, for: indexPath) as! BannerCVCell
        
       // cell.bannerImages.downloaded(from: banner_Images[indexPath.row])
        
        let imageLink = banner_Images[indexPath.row]
        cell.contentMode = .scaleToFill
        
        print("image size ",imageSize)
        print("Images ",imageLink)
        
        return cell
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if banner_Images.count == 0 {
            
        }else{
            currentIndex = Int(scrollView.contentOffset.x / bannersCV.frame.size.width)
            pagecontrol.currentPage = currentIndex
        }
        
    }
   
}

extension NewHomeViewController {
    
    func call_Banners() {
        
        guard let loginurl = URL(string: "http://dev.paysikka.com/api/user/banners") else {return}
        
        var url = URLRequest(url: loginurl)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSArray
                        
                        print("success ",recieved)
                        
                        for i in recieved {
                            
                            let banners = BannersModel(fromDictionary: i as? [String:Any] ?? ["":""])
                            
                            guard let BannnerIamge = banners.imageUrl else {return}
                            banner_Images.append(BannnerIamge)
                          
                        }
                        
                        DispatchQueue.main.async { [self] in
                            
                            bannersCV.reloadData()
                            startTimer()
                        }
                        
                        print("Banner ",banner_Images[0],banner_Images.count)
                        
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
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
    
    
//    func calling() {
//
//        let request = APIRequest(method: .get, path: <#T##String#>, headers: <#T##[HTTPHeader]#>, body: <#T##Data?#>)
//
//        APIClient().perform(request) { data in
//
//        }
//
//    }
    
    func getGramsBalance() {
        
        guard let loginurl = URL(string: "http://dev.paysikka.com/api/user/wallet") else {return}
        var url = URLRequest(url: loginurl)
        url.httpMethod = "GET"
        url.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let auth = UserDefaults.standard.string(forKey: "accessToken") ?? ""
        url.allHTTPHeaderFields = ["Authorization":auth]
        
        print("auth from HomePage getbal ",auth)
        
        let dataTask = URLSession.shared.dataTask(with: url) { [self] dataResponse, urlResponse, errorResponse in
            
            guard let data = dataResponse else {return}
            
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print(httpResponse.statusCode)
                
                if httpResponse.statusCode == 200 {
                    
                    do {
                        
                        let recieved = try JSONSerialization.jsonObject(with:data, options: JSONSerialization.ReadingOptions.allowFragments)  as! NSDictionary
                        
                        print("success ",recieved)
                        
                        let Balance = recieved["wallet"] as? Double ?? 0.0
                        let goldBalance = String(String(format:"%.02f", Balance))
                        globalGoldBalance = goldBalance
                         
                        DispatchQueue.main.async { [self] in
                            
                        goldgrams.text = "Gold Vault:           "+globalGoldBalance+" "+"grams"
                            
                        }
                        
                        print("globalGoldBalance ",globalGoldBalance)
                        
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
                    
                }
                
            }
            
        }
        dataTask.resume()
    }
    
}

extension NewHomeViewController:QRScannerCodeDelegate {
    
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String, scanDidCompletewith session: AVCaptureSession) {
        
        print("scanDidCompletewith session ",controller)
        
        session.stopRunning()
        
        if result.contains("upi://pay") {
            
            let enterAmonutScreen:EnterAmountScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterAmountScreen") as! EnterAmountScreen
            enterAmonutScreen.scannedData = result
            enterAmonutScreen.from = "UPI"
            DispatchQueue.main.async {
            self.navigationController?.pushViewController(enterAmonutScreen, animated: true)
            }
            
            
        }else{
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            let alert = UIAlertController(title: "Verification Failed", message: "Unable to verify QRCode \n Please try again.", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Scan Again", style: .default) { action in
               
                session.startRunning()
            }
            alert.view.tintColor = UIColor.init(named: "AppColor")
        
            alert.addAction(action)
            
            controller.present(alert, animated: true)
            
           let d = controller.isBeingDismissed
            
           let p = controller.isBeingPresented
            
           print("isBeingPresented ",p)
            
            print("isBeingDismissed ",d)
        
            
        }
       
        print("result:\(result)")
          
        
    }
    
/*
}else if result.contains("MAB"){
  
    let enterAmonutScreen:EnterAmountScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterAmountScreen") as! EnterAmountScreen
    enterAmonutScreen.scannedData = result
    enterAmonutScreen.from = "Bharat"
    DispatchQueue.main.async {
        self.navigationController?.pushViewController(enterAmonutScreen, animated: true)
        
    }*/
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
       
        print("scanDidComplete ViewC ",controller)
        
        if result.contains("upi://pay") {
            
            let enterAmonutScreen:EnterAmountScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterAmountScreen") as! EnterAmountScreen
            enterAmonutScreen.scannedData = result
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(enterAmonutScreen, animated: true)
                
            }
            
        }else{
            
            let alert = UIAlertController(title: "Verification Failed", message: "Unable to verify QRCode. \n Please try again.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Scan Again", style: .default)
            alert.view.tintColor = UIColor.link
        
            alert.addAction(action)
            
            controller.present(alert, animated: true)
            
           let p = controller.isBeingPresented
            
           print("isBeingPresented ",p)
            
        }
       
        print("result:\(result)")
        
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: QRCodeError) {
        
        
        print("error:\(error.localizedDescription)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        
        print("PAYQRScanner did cancel")
        
        self.dismiss(animated: true) {
//
//            let NewHome:NewTabBar = UIStoryboard(name: "NewHome", bundle: nil).instantiateViewController(withIdentifier: "NewTabBar") as! NewTabBar
//            NewHome.modalPresentationStyle = .fullScreen
//            self.navigationController?.pushViewController(NewHome, animated: true)
        }
        
        
    }
    
}
