//
//  SceneDelegate.swift
//  Paysikka
//
//  Created by George Praneeth on 21/06/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let user_state = UserDefaults.standard.bool(forKey: "userLoginState")
        
        print("user state ",user_state)
        
        let NewHome:PaysikkaTabBar = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "PaysikkaTabBar") as! PaysikkaTabBar
        
        //  let NewHome:NewTabBar = UIStoryboard(name: "NewHome", bundle: nil).instantiateViewController(withIdentifier: "NewTabBar") as! NewTabBar
        NewHome.modalPresentationStyle = .fullScreen
        window?.rootViewController = NewHome
        window?.makeKeyAndVisible()
        
        //        print("newHome TabBar isHidden from sceneDelegate ",NewHome.tabBarController?.tabBar.isHidden)
        
        /*if user_state {
         
         let NewHome:PaysikkaTabBar = UIStoryboard(name: "PaysikkaHome", bundle: nil).instantiateViewController(withIdentifier: "PaysikkaTabBar") as! PaysikkaTabBar
         //let NewHome = UIStoryboard(name: "NewHome", bundle: nil).instantiateViewController(withIdentifier: "NewTabBar") as! NewTabBar
         NewHome.modalPresentationStyle = .fullScreen
         window?.rootViewController = NewHome
         window?.makeKeyAndVisible()
         
         }else{
         
         let login:LoginViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
         login.modalPresentationStyle = .fullScreen
         window?.rootViewController = login
         window?.makeKeyAndVisible()
         
         }*/
        
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
        print(#function)
        
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
        print(#function)
        
        
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    /*
     func payment() {
     
     let alertcontrol = UIAlertController(title: "Transaction", message: "", preferredStyle: .actionSheet)
     
     let SuccessAction = UIAlertAction(title: "Success", style: .default){ [self] response in
     
     if response.title == "Success" {
     
     let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
     success.paymentStatusText = "Transaction Successful"
     success.paymentStatusImage = "successjson"
     success.paymentText = "Your Transaction has been Successful you will recieve your in 7 Working days"
     window?.rootViewController = success
     window?.makeKeyAndVisible()
     
     //  let payment = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "")
     
     //CallBuy_Gold()
     
     }
     
     }
     
     let FailAction = UIAlertAction(title: "Fail", style: .destructive) { [self] response in
     
     let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
     success.paymentStatusText = "Payment Failed"
     success.paymentStatusImage = "errorjson"
     success.paymentText = "Your Transaction has been faild if any money has been deducted will be returned 3 to 4 banking days"
     
     window?.rootViewController = success
     window?.makeKeyAndVisible()
     
     print("noaction: ",response)
     }
     
     let pendingAction = UIAlertAction(title: "Transaction In Progress", style: .default){ [self] response in
     
     if response.title == "Transaction In Progress" {
     
     let success :SuccessViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
     success.paymentStatusText = "Transaction In Progress"
     success.paymentStatusImage = "pendingjson"
     success.paymentText = "Your Transaction is in processing, Please Check again Later"
     
     window?.rootViewController = success
     window?.makeKeyAndVisible()
     
     }
     
     }
     
     
     alertcontrol.addAction(SuccessAction)
     alertcontrol.addAction(FailAction)
     alertcontrol.addAction(pendingAction)
     
     window?.rootViewController = alertcontrol
     window?.makeKeyAndVisible()
     
     }
     */
    
    
    
}

