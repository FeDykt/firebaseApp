//
//  Image.swift
//  firebaseApp
//
//  Created by fedot on 06.12.2021.
//

import UIKit

struct UrlToImage {
mutating func urlToImage<T: StringProtocol> (_ model: T) -> UIImage {
    let url = URL(string: model as! String)!
    let imageData = try! Data(contentsOf: url)
    let image = UIImage(data: imageData)
    return image!
    }
}
