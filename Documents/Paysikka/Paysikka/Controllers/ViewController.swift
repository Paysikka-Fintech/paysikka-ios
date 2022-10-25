//
//  ViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 21/06/22.
//

import UIKit
import AVKit

class ViewController: UIViewController {
    

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        
        return .portrait
        
    }
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        
    print("is tabBar Hidden ",self.tabBarController?.tabBarController?.tabBar.isHidden)
        
    }
    
    
  override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
      //  let cancelbutton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil )
      
      let scanner = QRCodeScannerController()
      scanner.delegate = self
      scanner.qrScannerConfiguration.readQRFromPhotos = true
      scanner.modalPresentationStyle = .automatic
      DispatchQueue.main.async {
      self.tabBarController?.tabBar.isHidden = true
      self.navigationController?.present(scanner, animated: true)
      
      }
      
      backButton(title: "Scan&Pay")
      
        let qr = view.inputViewController?.navigationController
      
      print("NAV ",qr)
      
      print("Success")
        
    }
}
extension ViewController: QRScannerCodeDelegate {
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String, scanDidCompletewith session: AVCaptureSession) {
        
    }
    
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
       
        let enterAmonutScreen:EnterAmountScreen = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EnterAmountScreen") as! EnterAmountScreen
        
        enterAmonutScreen.scannedData = result
        
        DispatchQueue.main.async {
        self.navigationController?.pushViewController(enterAmonutScreen, animated: true)
            
        }
       
        print("result:\(result)")
        
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: QRCodeError) {
        
        print("error:\(error.localizedDescription)")
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        
        print("PAYQRScanner did cancel")
        
        self.dismiss(animated: true) {
            
            let NewHome:NewTabBar = UIStoryboard(name: "NewHome", bundle: nil).instantiateViewController(withIdentifier: "NewTabBar") as! NewTabBar
            self.navigationController?.pushViewController(NewHome, animated: true)
        }
        
    }
    
}
