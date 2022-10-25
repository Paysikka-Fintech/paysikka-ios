//
//  LoadingOverlay.swift
//  FleetManagment
//
//  Created by Teja on 4/15/20.
//  Copyright © 2020 affluence. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView

public class LoadingOverlay {
    
    var overlayView = UIView()
    var activityIndicator : NVActivityIndicatorView!
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    init() {
        
        self.activityIndicator = NVActivityIndicatorView(frame:CGRect(x:overlayView.center.x, y: overlayView.center.y, width: 60, height: 60), type:.ballBeat, color:UIColor.init(named: "AppColor"), padding: 0)
        
        overlayView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.2)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1
        
        
        //        let blurEffect = UIBlurEffect(style:.extraLight)
        //        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurredEffectView.frame = overlayView.bounds
        //        overlayView.addSubview(blurredEffectView)
        //
        //        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        //        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        //        vibrancyEffectView.frame = overlayView.bounds
        //
        //        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        
        //        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.center = CGPoint(x: overlayView.bounds.width / 2, y: overlayView.bounds.height / 2)
        //        activityIndicator.style = .whiteLarge
        
        
        overlayView.addSubview(activityIndicator)
    }
    
    public func showOverlay() {
        //        let appDel = UIApplication.shared.delegate as! AppDelegate
        DispatchQueue.main.async {
            
            let holdingView = UIApplication.shared.keyWindow!
            // self.activityIndicator.center = holdingView.center
            // self.activityIndicator.startAnimating()
            
            self.overlayView.center = holdingView.center
            holdingView.addSubview(self.overlayView)
            self.activityIndicator.startAnimating()
           
//          UIApplication.shared.beginIgnoringInteractionEvents()
            
        }
        
    }
    
    public func hideOverlayView() {
        
//        DispatchQueue.main.async {
//
//            UIView.animate(withDuration: 4.0, delay: 0.4, options:.transitionCrossDissolve, animations: {
//                self.activityIndicator.stopAnimating()
//            }, completion: {(isCompleted) in
//                self.overlayView.removeFromSuperview()
//            })
//        }
        
        
        DispatchQueue.main.async {

            self.activityIndicator.stopAnimating()

            self.overlayView.removeFromSuperview()


//            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
    }
}
