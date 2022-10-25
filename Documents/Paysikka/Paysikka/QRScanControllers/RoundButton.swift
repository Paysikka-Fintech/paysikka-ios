//
//  RoundButton.swift
//  PaySikka-iOS
//
//  Created by George Praneeth on 17/06/22.
//

import Foundation
import UIKit

class RoundButton: UIButton {
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }
    
    func setup() {
        self.frame = frame
        self.tintColor = UIColor.white
        self.layer.cornerRadius = frame.size.height/2
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.contentMode = .scaleAspectFit
    }
}
