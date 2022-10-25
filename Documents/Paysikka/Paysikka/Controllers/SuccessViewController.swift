//
//  SuccessViewController.swift
//  Paysikka
//
//  Created by George Praneeth on 28/06/22.
//

import UIKit
import SDWebImage
import Lottie
import UIViewCanvas

class SuccessViewController: UIViewController {

    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    
    @IBOutlet weak var animationView: AnimationView!
    
    @IBOutlet weak var infotextview: UITextView!
    
    @IBOutlet weak var paymentinfoLbl: UILabel!
    
    var  paymentStatusImage:String = ""
    var paymentText:String = ""
    var paymentStatusText:String = ""
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  let gifName = "error"
        
     //   let imageData = try? Data(contentsOf: Bundle.main.url(forResource:gifName, withExtension: "data")!)
//        let advTimeGif = UIImage.gif(name:paymentStatusImage)
        
//        let animatedImage = SDAnimatedImage(named: "error")
//        paymentinfo.image = animatedImage
        
        animationView.animation = Animation.named(paymentStatusImage)
        
//        animationView.animation = Animation.named(paymentStatusImage, bundle:.main, subdirectory: "JSON Files")
        animationView.loopMode = .loop
        animationView.play()
       
        
//        if paymentStatusImage == "checkmark.seal.fill" {
//
//            paymentinfo.tintColor = .green
//            paymentinfo.image  = UIImage(systemName: paymentStatusImage)
//
//
//        } else {
//
//        paymentinfo.tintColor = .red
//        paymentinfo.image  = UIImage(named: paymentStatusImage)
//
//        }
        
        print("payment status ",paymentText)
        
        infotextview.text = paymentText
        infotextview.font = .boldSystemFont(ofSize: 16)
        paymentinfoLbl.text = paymentStatusText
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func proceedBtnTapped(_ sender: Any) {
        
        let NewHome:NewTabBar = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "NewTabBar") as! NewTabBar
        NewHome.modalPresentationStyle = .fullScreen
        self.present(NewHome, animated: true)
        
        
        
        
    }
    
    
}



