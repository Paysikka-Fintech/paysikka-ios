//
//  AppManager.swift
//  PaySikka-iOS
//
//  Created by George Praneeth on 17/06/22.
//

import Foundation
import UIKit

class AppManager: NSObject {
    class var sharedInstance: AppManager {
        struct Static {
            static let instance: AppManager = AppManager()
        }
        return Static.instance
    }
    
    func baseURL() -> String {
        return "https://jsonplaceholder.typicode.com"
    }
    
    func isUserLoggedIn() -> Bool {
           var isUserLoggedIn: Bool = false
           if Standards.preferences.bool(forKey: Standards.Key.isLoggedIn){
               isUserLoggedIn = Standards.preferences.bool(forKey: Standards.Key.isLoggedIn)
           }
           return isUserLoggedIn
       }
}

protocol StoryboardLoadable { }

extension StoryboardLoadable where Self: UIViewController {
  static var className: String {
    return String(describing: Self.self)
  }
  init(from storyboard: UIStoryboard) {
    let controller = storyboard
      .instantiateViewController(withIdentifier: Self.className)
    guard let viewController = controller as? Self else {
      fatalError("Could not initialize '\(Self.className)'")
    }
    self = viewController
  }
}

