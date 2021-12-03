//
//  TestTableViewCell.swift
//  firebaseApp
//
//  Created by fedot on 03.12.2021.
//

import UIKit

class TestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var firstImage: UIImageView!
    
    static let identifier = "TestTableViewCell"
    static func nib() -> UINib {
           return UINib(nibName: "TestTableViewCell", bundle: nil)
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ model: Model) {
        let imageUrl = URL(string: model.image)!
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData)
        
        self.firstImage.image = image
    }
    
}
