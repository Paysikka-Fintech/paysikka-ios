//
//  AppDelegate.swift
//  Paysikka
//
//  Created by George Praneeth on 21/06/22.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        // Override point for customization after application launch.
        
        switch UIApplication.shared.applicationState {
        case .active:
            print("Application active from appdelegate")
        case .inactive:
            print("Application inactive from appdelegate")
        case .background:
            print("Application background from appdelegate")
            
        default:
            print("Application state switch is in default")
        }
        
        let user_state = UserDefaults.standard.bool(forKey: "userLoginState")
        
        print("user state ",user_state)
        
        
        /*if user_state {
         
         window = UIWindow()
         window?.makeKeyAndVisible()
         
         let NewHome:NewHomeViewController = UIStoryboard(name: "NewHome", bundle: nil).instantiateViewController(withIdentifier: "NewHome") as! NewHomeViewController
         NewHome.modalPresentationStyle = .fullScreen
         window?.rootViewController = NewHome
         
         }else{
         
         window = UIWindow()
         window?.makeKeyAndVisible()
         
         let login:LoginViewController = UIStoryboard(name:"Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
         login.modalTransitionStyle = .flipHorizontal
         login.modalPresentationStyle = .fullScreen
         window?.rootViewController = login
         
         }*/
        
        return true
        
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

