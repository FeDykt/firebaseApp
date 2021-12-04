//
//  TestTableViewCell.swift
//  firebaseApp
//
//  Created by fedot on 03.12.2021.
//

import UIKit
import SnapKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userStackView: UIStackView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userButton: UIButton!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var postInfoStackView: UIStackView!
    
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var postLikes: UILabel!
    
    static let identifier = "PostTableViewCell"
    static func nib() -> UINib {
           return UINib(nibName: "PostTableViewCell", bundle: nil)
       }

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        settingViews()
    }
    
    func configure(_ model: Model) {
        let imageUrl = URL(string: model.image)!
        let imageData = try! Data(contentsOf: imageUrl)
        let image = UIImage(data: imageData)
        
        self.postImage.image = image
        self.userImage.image = image
        self.userName.text = model.name
    }
    
}

extension PostTableViewCell {
    func settingViews() {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2


    }
}
