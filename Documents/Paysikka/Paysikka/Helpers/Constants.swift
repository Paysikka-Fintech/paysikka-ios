//
//  Constants.swift
//  PaySikka-iOS
//
//  Created by George Praneeth on 17/06/22.
//

import Foundation
import UIKit

let imageCache = NSCache<NSString, UIImage>()

let kFontRobotoRegular = "Roboto-Regular"
let kFontRobotoBold = "Roboto-Bold"
let kFontRobotoMedium = "Roboto-Medium"
let kFontRobotoLight = "Roboto-Light"
let kFontRobotoThin = "Roboto-Thin"

let BaseURL = "https://dev.paysikka.com/api/"

enum Providers:String {
case Prepaid = "Prepaid-Mobile"
case Postpaid = "Postpaid-Mobile"
case Electricity = "Electricity"
case Landline = "Landline"
case Dishtv = "DTH"
case Operators = "operators"
case Circles = "circles"
case BroadbandPrepaid = "Broadband"
case DataCard = "Datacard"
case Gas = "GAS"
case Insurance = "Insurance"
case Water = "Water"
case LoanRepayment = "Loan Repayment"
case LifeInsurance = "Life Insurance"
case BroadPostpaid = "Broadband Postpaid"
}
