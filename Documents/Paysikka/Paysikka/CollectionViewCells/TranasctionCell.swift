//
//  TranasctionCell.swift
//  Paysikka
//
//  Created by George Praneeth on 11/07/22.
//

import UIKit

class TranasctionCell: UICollectionViewCell {
  
    static let identifier = "TranscationCell"
    
    @IBOutlet weak var transaction_Message: UILabel!
    
    @IBOutlet weak var transactionID: UILabel!
    
    @IBOutlet weak var gramsadded: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
