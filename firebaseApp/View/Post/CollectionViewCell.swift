//
//  CollectionViewCell.swift
//  firebaseApp
//
//  Created by fedot on 09.12.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    static func nib() -> UINib {
           return UINib(nibName: "CollectionViewCell", bundle: nil)
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        image.clipsToBounds = true
    }

    
    
}
