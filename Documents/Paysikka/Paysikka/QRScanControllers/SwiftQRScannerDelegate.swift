//
//  SwiftQRScannerDelegate.swift
//  PaySikka-iOS
//
//  Created by George Praneeth on 17/06/22.
//

import Foundation
import UIKit
import AVKit

/**
 This protocol defines methods which get called when some events occures.
 */
public protocol QRScannerCodeDelegate: AnyObject {
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String)
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String,scanDidCompletewith session:AVCaptureSession)
    func qrScannerDidFail(_ controller: UIViewController,  error: QRCodeError)
    func qrScannerDidCancel(_ controller: UIViewController)
}
