//
//  SectionsCollectionViewCell.swift
//  Paysikka
//
//  Created by George Praneeth on 20/08/22.
//

import UIKit

class SectionsCollectionViewCell: UICollectionViewCell {

    static let identifier = "SectionsCVCell"
    
    @IBOutlet weak var providerimg: UIImageView!
    
    @IBOutlet weak var providerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

}
