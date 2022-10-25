//
//  ScreenDimensions.swift
//  PaySikka-iOS
//
//  Created by George Praneeth on 17/06/22.
//

import Foundation
import UIKit

//iPhone 4, iPhone 4s
let iPhone4 = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 480)

//iPhone 5, iPhone 5s, iPhone 5c, iPhone SE
let iPhone5Sizes = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 568)

//iPhone 6, iPhone 6s, iPhone7, iPhone8
let iPhone6Sizes = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 667)

//iPhone 6+, iPhone 6s+, iPhone 7+, iPhone 8+
let iPhonePlusSizes = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 736)

//iPhone 11 Pro, iPhone X, iPhone Xs
let iPhoneXSizes = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 812)

// iPhone 11 Pro Max, iPhone Xs Max, iPhone 11, iPhone XR
let iPhoneXRSizes = (UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.size.height == 896)

