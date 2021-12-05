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
    
    func urlToImage<T: StringProtocol> (_ model: T) -> UIImage {
        let url = URL(string: model as! String)!
        let imageData = try! Data(contentsOf: url)
        let image = UIImage(data: imageData)
        return image!
    }
    
    func configure(_ model: Model) {
        let image = urlToImage(model.image)
        let avatar = urlToImage(model.avatar)
        
        self.postImage.image = image
        self.userImage.image = avatar
        self.userName.text = model.name
    }
    
}

extension PostTableViewCell {
    func settingViews() {
        userImage.layer.cornerRadius = userImage.frame.size.width / 2
    }
}
