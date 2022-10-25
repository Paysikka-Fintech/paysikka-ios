//
//  DownloadImageExtention.swift
//  ProtiensApp
//
//  Created by mehtab alam on 15/12/2020.
//

import Foundation
import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
    func downloaded(from url:String){
        if let url = URL(string:url) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data,error == nil else { return }
             
                DispatchQueue.main.async { /// execute on main thread
                    self.image = UIImage(data: data)
                }
            }
            
            task.resume()
        }
    }

    func makeRounded() {

       // self.layer.borderWidth = 1
        self.layer.masksToBounds = false
//        self.layer.borderColor = UIColor.black.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    func ImageViewRoundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
}
extension UIButton {
func makeRounded() {

   // self.layer.borderWidth = 1
    self.layer.masksToBounds = false
//        self.layer.borderColor = UIColor.black.cgColor
    self.layer.cornerRadius = self.frame.height / 2
    self.clipsToBounds = true
    self.layer.masksToBounds = true
}
}
