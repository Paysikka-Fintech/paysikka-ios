//
//  UIImage+Extension.swift
//  PaySikka-iOS
//
//  Created by George Praneeth on 17/06/22.
//

import Foundation
import UIKit

extension UIImage {
    func parseQR() -> String? {
        guard let image = CIImage(image: self) else {
            return nil
        }
        let detector = CIDetector(ofType: CIDetectorTypeQRCode,
                                  context: nil,
                                  options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        let features = detector?.features(in: image) ?? []
        return features.compactMap { feature in
            return (feature as? CIQRCodeFeature)?.messageString
        }.joined()
    }
}
