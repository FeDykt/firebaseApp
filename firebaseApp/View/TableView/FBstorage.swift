//
//  FBstorage.swift
//  firebaseApp
//
//  Created by fedot on 03.12.2021.
//

import Foundation
import Firebase
import UIKit

class FBstorage {
    var photo = UIImageView()
    
    func getImage(currentUserId: String, photo: UIImage, completion: @escaping (Result<URL, Error>) -> Void ) {
        let storage = Storage.storage().reference().child("image").child(currentUserId)
        guard let imageData = photo.jpegData(compressionQuality: 0.5) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storage.putData(imageData, metadata: metaData) { metadata, error in
            guard let _ = metadata else { completion(.failure(error!)); return }
            storage.downloadURL { url, error in
                guard let url = url else { completion(.failure(error!)); return }
                completion(.success(url))
            }
            
        }
        
    }
    


//        let forestRef = Storage.storage().reference().child("image")
//        let dataSize = Int64(10 * 1024 * 1024)
//        pathReference.getData(maxSize: dataSize) { data, error in
//            guard let data = data else { print("error getData: \(error)"); return }
//            print("data: \(data)")
//         }
        }
    
    
        

   

